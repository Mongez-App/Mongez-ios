import Foundation

public enum CalendarSyncError: Error, LocalizedError {
    case accessDenied

    public var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Calendar access was denied. You can enable it later in Settings."
        }
    }
}

public protocol CalendarSyncManaging {
    var authorizationStatus: CalendarAuthorizationStatus { get }

    func requestAccess() async throws -> Bool

    @discardableResult
    func syncNow() async throws -> Int

    func startContinuousSync(onSyncCompleted: ((Result<Int, Error>) -> Void)?)
    func stopContinuousSync()

    func fetchStatus() async throws -> CalendarSyncStatus

    @discardableResult
    func updateFlags(calendarConnected: Bool, calendarSynced: Bool) async throws -> CalendarSyncStatus
}
