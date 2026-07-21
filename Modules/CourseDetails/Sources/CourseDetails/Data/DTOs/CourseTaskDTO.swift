//
//  File.swift
//  
//
//  Created by Mazen Amr on 21/07/2026.
//

import Foundation

public struct CourseTaskDTO: Decodable {
    public let task_id: String
    public let title: String
    public let duration_minutes: Int
    public let priority: String
    public let is_completed: Bool
    public let task_start_date: String
}

public extension CourseTaskDTO {
    func toDomain(group: TaskGroup) -> CourseTask {
        return CourseTask(
            id: task_id,
            title: title,
            durationMinutes: duration_minutes,
            priority: TaskPriority(rawValue: priority) ?? .medium,
            isCompleted: is_completed,
            group: group
        )
    }
}
