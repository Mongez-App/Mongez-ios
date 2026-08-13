import BackgroundTasks
import Foundation

public final class CalendarSyncManager: CalendarSyncManaging {
    public static let shared = CalendarSyncManager()

    private static let backgroundTaskIdentifier = "app.mongez.calendarSync.refresh"
    private static let syncWindow: TimeInterval = 30 * 24 * 60 * 60
    private static let autoSyncStaleInterval: TimeInterval = 30 * 24 * 60 * 60
    private static let backgroundRefreshInterval: TimeInterval = 15 * 60
    private static let debounceInterval: UInt64 = 2_000_000_000

    private let eventReader: EventKitEventReader
    private let remoteDataSource: CalendarSyncRemoteDataSourceProtocol

    private var changeObserverToken: NSObjectProtocol?
    private var onSyncCompleted: ((Result<Int, Error>) -> Void)?
    private var debounceTask: Task<Void, Never>?

    private init(
        eventReader: EventKitEventReader = EventKitEventReader(),
        remoteDataSource: CalendarSyncRemoteDataSourceProtocol = CalendarSyncRemoteDataSource()
    ) {
        self.eventReader = eventReader
        self.remoteDataSource = remoteDataSource
    }

    public var authorizationStatus: CalendarAuthorizationStatus {
        eventReader.authorizationStatus
    }

    public func requestAccess() async throws -> Bool {
        let granted = try await eventReader.requestAccess()
        guard granted else { throw CalendarSyncError.accessDenied }
        return granted
    }

    @discardableResult
    public func syncNow() async throws -> Int {
        guard authorizationStatus == .authorized else {
            throw CalendarSyncError.accessDenied
        }
        let now = Date()
        let events = eventReader.fetchEvents(from: now, to: now.addingTimeInterval(Self.syncWindow))
        let count = events.isEmpty ? 0 : try await remoteDataSource.syncEvents(events)
        try await remoteDataSource.updateFlags(calendarConnected: true, calendarSynced: true)
        return count
    }

    public func fetchStatus() async throws -> CalendarSyncStatus {
        try await remoteDataSource.getStatus()
    }

    @discardableResult
    public func updateFlags(calendarConnected: Bool, calendarSynced: Bool) async throws -> CalendarSyncStatus {
        try await remoteDataSource.updateFlags(calendarConnected: calendarConnected, calendarSynced: calendarSynced)
    }

    public func startContinuousSync(onSyncCompleted: ((Result<Int, Error>) -> Void)? = nil) {
        self.onSyncCompleted = onSyncCompleted
        syncNowIfStale()
        guard changeObserverToken == nil else { return }
        changeObserverToken = eventReader.observeChanges { [weak self] in
            self?.scheduleDebouncedSync()
        }
        scheduleNextBackgroundRefresh()
    }

    /// Guarantees a sync happens at least once every 30 days, even if no calendar
    /// changes fired the change observer and background refresh never ran.
    private func syncNowIfStale() {
        guard authorizationStatus == .authorized else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                let status = try await self.remoteDataSource.getStatus()
                let isStale = status.lastCalendarSyncAt.map {
                    Date().timeIntervalSince($0) >= Self.autoSyncStaleInterval
                } ?? true
                guard isStale else { return }
                let count = try await self.syncNow()
                self.onSyncCompleted?(.success(count))
            } catch {
                self.onSyncCompleted?(.failure(error))
            }
        }
    }

    public func stopContinuousSync() {
        if let token = changeObserverToken {
            eventReader.removeObserver(token)
            changeObserverToken = nil
        }
        debounceTask?.cancel()
        debounceTask = nil
        onSyncCompleted = nil
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: Self.backgroundTaskIdentifier)
    }

    private func scheduleDebouncedSync() {
        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: Self.debounceInterval)
            guard let self, !Task.isCancelled else { return }
            do {
                let count = try await self.syncNow()
                self.onSyncCompleted?(.success(count))
            } catch {
                self.onSyncCompleted?(.failure(error))
            }
        }
    }

    // MARK: - Background refresh

    /// Must be called before `application(_:didFinishLaunchingWithOptions:)` returns.
    public func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: Self.backgroundTaskIdentifier, using: nil) { [weak self] task in
            guard let refreshTask = task as? BGAppRefreshTask else {
                task.setTaskCompleted(success: false)
                return
            }
            self?.handleBackgroundRefresh(task: refreshTask)
        }
    }

    private func handleBackgroundRefresh(task: BGAppRefreshTask) {
        scheduleNextBackgroundRefresh()

        let syncTask = Task {
            do {
                _ = try await syncNow()
                task.setTaskCompleted(success: true)
            } catch {
                task.setTaskCompleted(success: false)
            }
        }

        task.expirationHandler = {
            syncTask.cancel()
        }
    }

    private func scheduleNextBackgroundRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: Self.backgroundTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: Self.backgroundRefreshInterval)
        try? BGTaskScheduler.shared.submit(request)
    }
}
