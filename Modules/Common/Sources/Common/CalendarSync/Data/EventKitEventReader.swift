import EventKit
import Foundation

final class EventKitEventReader {
    private let eventStore = EKEventStore()

    var authorizationStatus: CalendarAuthorizationStatus {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .authorized:
            return .authorized
        default:
            // iOS 17+ adds .fullAccess / .writeOnly; only full access lets us read events.
            if #available(iOS 17.0, *), status == .fullAccess {
                return .authorized
            }
            return .denied
        }
    }

    func requestAccess() async throws -> Bool {
        if #available(iOS 17.0, *) {
            return try await eventStore.requestFullAccessToEvents()
        } else {
            return try await eventStore.requestAccess(to: .event)
        }
    }

    func fetchEvents(from startDate: Date, to endDate: Date) -> [CalendarEventEntity] {
        let calendars = eventStore.calendars(for: .event)
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)

        return eventStore.events(matching: predicate).map { event in
            CalendarEventEntity(
                externalId: event.eventIdentifier,
                title: event.title ?? "Untitled",
                startDate: event.startDate,
                endDate: event.endDate,
                calendarName: event.calendar?.title
            )
        }
    }

    func observeChanges(_ handler: @escaping () -> Void) -> NSObjectProtocol {
        NotificationCenter.default.addObserver(
            forName: .EKEventStoreChanged,
            object: eventStore,
            queue: .main
        ) { _ in handler() }
    }

    func removeObserver(_ token: NSObjectProtocol) {
        NotificationCenter.default.removeObserver(token)
    }
}
