import Foundation

// This DTO talks to a different backend service (api-gateway-production-3fd0) than the rest of
// CalendarSync (getStatus/updateFlags hit api-gateway-production-5110, which uses snake_case like
// the rest of the app) — this one expects camelCase keys, so no custom CodingKeys here.
struct CalendarEventDto: Codable {
    let externalId: String
    let title: String
    let startDate: Date
    let endDate: Date
    let calendarName: String?
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

// Same camelCase service as CalendarEventDto above — see that comment.
// Actual response shape: {"success":true,"message":"...","createdCount":0,"data":[]}
struct CalendarSyncResponseDto: Decodable {
    let createdCount: Int
}
