import Foundation

struct CalendarSyncStatusDto: Decodable {
    let calendarConnected: Bool
    let calendarSynced: Bool
    let lastCalendarSyncAt: String?

    enum CodingKeys: String, CodingKey {
        case calendarConnected = "calendar_connected"
        case calendarSynced = "calendar_synced"
        case lastCalendarSyncAt = "last_calendar_sync_at"
    }

    func mapToEntity() -> CalendarSyncStatus {
        CalendarSyncStatus(
            calendarConnected: calendarConnected,
            calendarSynced: calendarSynced,
            lastCalendarSyncAt: Self.parseDate(lastCalendarSyncAt)
        )
    }

    private static func parseDate(_ string: String?) -> Date? {
        guard let string else { return nil }
        let withFractionalSeconds = ISO8601DateFormatter()
        withFractionalSeconds.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let withoutFractionalSeconds = ISO8601DateFormatter()
        withoutFractionalSeconds.formatOptions = [.withInternetDateTime]

        return withFractionalSeconds.date(from: string) ?? withoutFractionalSeconds.date(from: string)
    }
}
