//
//  DelayedTask.swift
//  Dashboard
//
//  Created by Extern Dev
//

import Foundation

/// The action to apply to a delayed task when rescheduling.
public enum DelayedAction: String, CaseIterable, Sendable {
    /// Mark the task as done.
    case markCompleted = "mark_completed"
    /// Move the task to today's schedule.
    case shiftToToday = "shift_to_today"

    public var title: String {
        switch self {
        case .markCompleted: return "Mark as Done"
        case .shiftToToday: return "Reschedule to Today"
        }
    }
}

/// A task that was not completed on its scheduled day.
public struct DelayedTask: Identifiable, Sendable {
    public let taskId: String
    public let courseId: String?
    public let title: String
    public let courseName: String?
    public let dueText: String?
    public let dueDate: String?

    public var id: String { taskId }

    public init(
        taskId: String,
        courseId: String?,
        title: String,
        courseName: String?,
        dueText: String?,
        dueDate: String?
    ) {
        self.taskId = taskId
        self.courseId = courseId
        self.title = title
        self.courseName = courseName
        self.dueText = dueText
        self.dueDate = dueDate
    }
}