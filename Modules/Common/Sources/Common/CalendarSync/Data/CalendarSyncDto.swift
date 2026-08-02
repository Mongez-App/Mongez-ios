import Foundation

struct CalendarEventDto: Codable {
    let externalId: String
    let title: String
    let startDate: Date
    let endDate: Date
    let calendarName: String?

    enum CodingKeys: String, CodingKey {
        case externalId = "external_id"
        case title
        case startDate = "start_date"
        case endDate = "end_date"
        case calendarName = "calendar_name"
    }
}

extension CalendarEventEntity {
    func mapToDto() -> CalendarEventDto {
        CalendarEventDto(
            externalId: externalId,
            title: title,
            startDate: startDate,
            endDate: endDate,
            calendarName: calendarName
        )
    }
}

struct CalendarSyncResponseDto: Decodable {
    let syncedCount: Int

    enum CodingKeys: String, CodingKey {
        case syncedCount = "synced_count"
    }
}
