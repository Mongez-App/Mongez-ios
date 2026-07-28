import Foundation

public struct RoadmapResponseDTO: Decodable {
    let success: Bool?
    let data: RoadmapDTO?
    let message: String?
}

public struct RoadmapDTO: Decodable {
    let roadmapStartDate: String?
    let weeks: [WeekDTO]

    enum CodingKeys: String, CodingKey {
        case roadmapStartDate = "roadmap_start_date"
        case weeks
    }

    public static func mapToEntity(_ dto: RoadmapDTO) -> Roadmap {
        Roadmap(
            roadmapStartDate: dto.roadmapStartDate ?? "",
            weeks: dto.weeks.map { WeekDTO.mapToEntity($0) }
        )
    }
}

public struct WeekDTO: Decodable {
    let weekNumber: Int
    let startDate: String
    let endDate: String
    let studyBlocks: [StudyBlockDTO]

    enum CodingKeys: String, CodingKey {
        case weekNumber = "week_number"
        case startDate = "start_date"
        case endDate = "end_date"
        case studyBlocks = "study_blocks"
    }

    public static func mapToEntity(_ dto: WeekDTO) -> Week {
        Week(
            weekNumber: dto.weekNumber,
            startDate: dto.startDate,
            endDate: dto.endDate,
            studyBlocks: dto.studyBlocks.map { StudyBlockDTO.mapToEntity($0) }
        )
    }
}

public struct StudyBlockDTO: Decodable {
    let blockId: String
    let courseId: String
    let courseName: String
    let tasks: [RoadmapTaskDTO]
    let isCompleted: Bool
    let events: [RoadmapEventDTO]

    enum CodingKeys: String, CodingKey {
        case blockId = "block_id"
        case courseId = "course_id"
        case courseName = "course_name"
        case tasks
        case isCompleted = "is_completed"
        case events
    }

    public static func mapToEntity(_ dto: StudyBlockDTO) -> StudyBlock {
        StudyBlock(
            blockId: dto.blockId,
            courseId: dto.courseId,
            courseName: dto.courseName,
            tasks: dto.tasks.map { RoadmapTaskDTO.mapToEntity($0) },
            isCompleted: dto.isCompleted,
            events: dto.events.map { RoadmapEventDTO.mapToEntity($0) }
        )
    }
}

public struct RoadmapTaskDTO: Decodable {
    let topic: String
    let durationMinutes: Int
    let taskDate: String?
    let dayNumber: Int?

    enum CodingKeys: String, CodingKey {
        case topic
        case durationMinutes = "duration_minutes"
        case taskDate = "task_date"
        case dayNumber = "day_number"
    }

    public static func mapToEntity(_ dto: RoadmapTaskDTO) -> RoadmapTask {
        RoadmapTask(
            topic: dto.topic,
            durationMinutes: dto.durationMinutes,
            taskDate: dto.taskDate ?? ""
        )
    }
}

public struct RoadmapEventDTO: Decodable {
    let eventId: String
    let courseId: String
    let courseName: String
    let title: String
    let eventType: String
    let eventDate: String

    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case courseId = "course_id"
        case courseName = "course_name"
        case title
        case eventType = "event_type"
        case eventDate = "event_date"
    }

    public static func mapToEntity(_ dto: RoadmapEventDTO) -> Event {
        Event(
            title: dto.title,
            eventType: dto.eventType,
            eventDate: dto.eventDate
        )
    }
}
