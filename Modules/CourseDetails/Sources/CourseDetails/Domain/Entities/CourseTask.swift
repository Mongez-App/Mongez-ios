//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
public enum TaskPriority: String {
    case high = "HIGH"
    case medium = "MEDIUM"
    case low = "LOW"
}

public enum TaskGroup: String {
    case today = "Today Tasks"
    case upcoming = "Upcoming Tasks"
}

public struct CourseTask: Identifiable {
    public let id: String
    public let title: String
    public let durationMinutes: Int
    public let priority: TaskPriority
    public let isCompleted: Bool
    public let group: TaskGroup
    
    public init(id: String, title: String, durationMinutes: Int, priority: TaskPriority, isCompleted: Bool, group: TaskGroup) {
        self.id = id
        self.title = title
        self.durationMinutes = durationMinutes
        self.priority = priority
        self.isCompleted = isCompleted
        self.group = group
    }
}
