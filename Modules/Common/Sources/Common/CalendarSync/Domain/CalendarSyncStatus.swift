import Foundation

public struct CalendarSyncStatus: Equatable {
    public let calendarConnected: Bool
    public let calendarSynced: Bool
    public let lastCalendarSyncAt: Date?

    public init(calendarConnected: Bool, calendarSynced: Bool, lastCalendarSyncAt: Date?) {
        self.calendarConnected = calendarConnected
        self.calendarSynced = calendarSynced
        self.lastCalendarSyncAt = lastCalendarSyncAt
    }

    /// Human-readable form of `lastCalendarSyncAt`, e.g. "Aug 13, 2026 at 4:23 PM".
    public var lastSyncedReadableDate: String {
        guard let lastCalendarSyncAt else { return "Never" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: lastCalendarSyncAt)
    }
}
