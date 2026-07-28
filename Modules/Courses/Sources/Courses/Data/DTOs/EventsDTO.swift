import Foundation

struct CreateEventRequestDTO: Codable {
    let eventType: String
    let title: String
    let dueDate: String
    let weight: Int
}

struct EventsListWrapperDTO: Decodable {
    let success: Bool?
    let data: EventsListDataDTO?
    let message: String?
}

struct EventsListDataDTO: Decodable {
    let courseId: String?
    let eventCount: Int?
    let events: [CourseEventDTO]?
}

struct CourseEventDTO: Decodable {
    let id: String?
    let eventType: String?
    let title: String?
    let dueDate: String?
    let weight: Int?
    let courseId: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "eventId"
        case eventType
        case title
        case dueDate
        case weight
        case courseId
        case createdAt
    }

    func toDomain() -> CourseEvent {
        CourseEvent(
            id: id ?? UUID().uuidString,
            eventType: eventType ?? "other",
            title: title ?? "Untitled",
            dueDate: dueDate ?? "",
            weight: weight ?? 0,
            courseId: courseId ?? ""
        )
    }
}
