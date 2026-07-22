//
//  File.swift
//
//
//  Created by Ahmed Tarek on 22/07/2026.
//

import Foundation


struct RoadmapDTO: Codable {
    let roadmapStartDate: String
    let weeks: [WeekDTO]
    
    enum CodingKeys: String, CodingKey {
        case roadmapStartDate = "roadmap_start_date"
        case weeks
    }
    
    static func mapToEntity(_ dto: RoadmapDTO) -> Roadmap {
        Roadmap(
            roadmapStartDate: dto.roadmapStartDate,
            weeks: dto.weeks.map { WeekDTO.mapToEntity($0) }
        )
    }
}

struct WeekDTO: Codable {
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
    
    static func mapToEntity(_ dto: WeekDTO) -> Week {
        Week(
            weekNumber: dto.weekNumber,
            startDate: dto.startDate,
            endDate: dto.endDate,
            studyBlocks: dto.studyBlocks.map { StudyBlockDTO.mapToEntity($0) }
        )
    }
}

struct StudyBlockDTO: Codable {
    let blockId: String
    let courseId: String
    let courseName: String
    let tasks: [TaskDTO]
    let isCompleted: Bool
    let events: [EventDTO]
    
    enum CodingKeys: String, CodingKey {
        case blockId = "block_id"
        case courseId = "course_id"
        case courseName = "course_name"
        case tasks
        case isCompleted = "is_completed"
        case events
    }
    
    static func mapToEntity(_ dto: StudyBlockDTO) -> StudyBlock {
        StudyBlock(
            blockId: dto.blockId,
            courseId: dto.courseId,
            courseName: dto.courseName,
            tasks: dto.tasks.map { TaskDTO.mapToEntity($0) },
            isCompleted: dto.isCompleted,
            events: dto.events.map { EventDTO.mapToEntity($0) }
        )
    }
}

struct TaskDTO: Codable {
    let topic: String
    let durationMinutes: Int
    let taskDate: String
    
    enum CodingKeys: String, CodingKey {
        case topic
        case durationMinutes = "duration_minutes"
        case taskDate = "task_date"
    }
    
    static func mapToEntity(_ dto: TaskDTO) -> Task {
        Task(
            topic: dto.topic,
            durationMinutes: dto.durationMinutes,
            taskDate: dto.taskDate
        )
    }
}

struct EventDTO: Codable {
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
    
    static func mapToEntity(_ dto: EventDTO) -> Event {
        Event(
            title: dto.title,
            eventType: dto.eventType,
            eventDate: dto.eventDate
        )
    }
}

