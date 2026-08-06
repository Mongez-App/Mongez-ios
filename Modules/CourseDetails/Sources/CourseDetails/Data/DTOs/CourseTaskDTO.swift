//
//  File.swift
//  
//
//  Created by Mazen Amr on 21/07/2026.
//

import Foundation

public struct CourseTaskDTO: Codable {
    public let task_id: String
    public let title: String
    public let duration_minutes: Int
    public let priority: String
    public let is_completed: Bool
    public let date: String?
    public let course_id: String?
    public let sequence_order: Int?
    
    enum CodingKeys: String, CodingKey {
        case task_id = "id"
        case title
        case duration_minutes
        case priority
        case is_completed = "completed"
        case date = "scheduled_date"
        case course_id
        case sequence_order
    }
}

public extension CourseTaskDTO {
    func toDomain() -> CourseTask {
        let mappedPriority: CourseTask.Priority
        switch priority.uppercased() {
        case "HIGH": mappedPriority = .high
        case "MEDIUM": mappedPriority = .medium
        case "LOW": mappedPriority = .low
        default: mappedPriority = .medium
        }

        var mappedGroup: CourseTask.Group = .upcoming
        if let dateString = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let taskDate = formatter.date(from: dateString), Calendar.current.isDateInToday(taskDate) {
                mappedGroup = .today
            }
        }
        
        return CourseTask(
            id: task_id,
            title: title,
            durationMinutes: duration_minutes,
            priority: mappedPriority,
            isCompleted: is_completed,
            group: mappedGroup
        )
    }
}
