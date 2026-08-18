import Foundation

struct TeamCoursesResponseDTO: Decodable {
    let teamId: String?
    let courses: [TeamCourseDTO]?
    let total: Int?
}

struct TeamCourseDTO: Decodable {
    let id: String?
    let name: String?
    let progress: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case _id
        case courseId = "course_id"
        case name
        case progress
        case completionPercentage = "completion_percentage"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let id = try container.decodeIfPresent(String.self, forKey: .id) {
            self.id = id
        } else if let courseId = try container.decodeIfPresent(String.self, forKey: .courseId) {
            self.id = courseId
        } else {
            self.id = try container.decodeIfPresent(String.self, forKey: ._id)
        }
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        
        if let completion = try container.decodeIfPresent(Double.self, forKey: .completionPercentage) {
            self.progress = completion
        } else {
            self.progress = try container.decodeIfPresent(Double.self, forKey: .progress)
        }
    }
    
    func toDomain() -> TeamCourse {
        let rawName = name ?? "Untitled Course"
        var actualName = rawName
        var orgId: String? = nil
        var thumbnailUrl: String? = nil
        
        let components = rawName.components(separatedBy: "|")
        if components.count == 3 {
            orgId = components[0]
            actualName = components[1]
            thumbnailUrl = components[2]
        } else if let underscoreIndex = rawName.firstIndex(of: "_") {
            orgId = String(rawName[..<underscoreIndex])
            actualName = String(rawName[rawName.index(after: underscoreIndex)...])
        }
        
        return TeamCourse(
            id: id ?? UUID().uuidString,
            name: actualName,
            progress: progress ?? 0.0,
            organizationId: orgId,
            thumbnailUrl: thumbnailUrl
        )
    }
}

struct TeamEventsResponseDTO: Decodable {
    let teamId: String?
    let events: [TeamEventDTO]?
    let total: Int?
}

struct TeamEventDTO: Decodable {
    let id: String?
    let courseName: String?
    let eventType: String?
    let eventDate: String?
    let daysLeft: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case _id
        case courseName = "course_name"
        case eventType = "event_type"
        case eventDate = "event_date"
        case daysLeft = "days_left"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let id = try container.decodeIfPresent(String.self, forKey: .id) {
            self.id = id
        } else {
            self.id = try container.decodeIfPresent(String.self, forKey: ._id)
        }
        self.courseName = try container.decodeIfPresent(String.self, forKey: .courseName)
        self.eventType = try container.decodeIfPresent(String.self, forKey: .eventType)
        self.eventDate = try container.decodeIfPresent(String.self, forKey: .eventDate)
        self.daysLeft = try container.decodeIfPresent(Int.self, forKey: .daysLeft)
    }
    
    func toDomain() -> TeamEvent {
        return TeamEvent(
            id: id ?? UUID().uuidString,
            courseName: courseName ?? "Unknown Course",
            eventType: eventType ?? "Event",
            eventDate: eventDate ?? "",
            daysLeft: daysLeft ?? 0
        )
    }
}
