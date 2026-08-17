//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation

public struct TeamCourseTask: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let durationMinutes: Int
    public let priority: Priority
    public let isCompleted: Bool
    public let group: Group
    public let date: String?
    public let activeSpentTime: Int
    
    public enum Priority: String, Equatable {
        case high, medium, low
    }
    
    public enum Group: String, Equatable {
        case today, upcoming
    }
    
    public init(
        id: String,
        title: String,
        durationMinutes: Int,
        priority: Priority,
        isCompleted: Bool,
        group: Group,
        date: String? = nil,
        activeSpentTime: Int = 0
    ) {
        self.id = id
        self.title = title
        self.durationMinutes = durationMinutes
        self.priority = priority
        self.isCompleted = isCompleted
        self.group = group
        self.date = date
        self.activeSpentTime = activeSpentTime
    }
}
