//
//  DelayedTasksDTO.swift
//  Dashboard
//
//  Created by Extern Dev
//

import Foundation

/// Wrapped response for `GET /api/v1/rag/tasks/delayed`.
public struct DelayedTasksResponseDTO: Decodable {
    public let success: Bool?
    public let message: String?
    public let data: DelayedTasksDataDTO?

    enum CodingKeys: String, CodingKey {
        case success, message, data
    }

    /// Total number of delayed tasks reported by the backend.
    public var totalDelayed: Int {
        data?.totalDelayed ?? data?.tasks?.count ?? 0
    }

    public var tasks: [DelayedTaskDTO] {
        data?.tasks ?? []
    }
}

public struct DelayedTasksDataDTO: Decodable {
    public let totalDelayed: Int?
    public let tasks: [DelayedTaskDTO]?

    enum CodingKeys: String, CodingKey {
        case totalDelayed = "total_delayed"
        case tasks = "delayed_tasks"
    }
}

public struct DelayedTaskDTO: Decodable {
    public let taskId: String?
    public let courseId: String?
    public let title: String?
    public let courseName: String?
    public let dueText: String?
    public let dueDate: String?

    enum CodingKeys: String, CodingKey {
        case taskId = "task_id"
        case courseId = "course_id"
        case title
        case courseName = "course_name"
        case dueText = "due_text"
        case dueDate = "due_date"
    }

    public func toDomain() -> DelayedTask? {
        guard let taskId, !taskId.isEmpty else { return nil }
        return DelayedTask(
            taskId: taskId,
            courseId: courseId,
            title: title ?? "Untitled task",
            courseName: courseName,
            dueText: dueText,
            dueDate: dueDate
        )
    }
}

// MARK: - Reschedule request

/// One task/action pair inside the `tasks` array of the reschedule request.
public struct DelayedTaskActionDTO: Encodable, Sendable {
    public let taskId: String
    public let courseId: String?
    public let action: String

    public init(taskId: String, courseId: String?, action: String) {
        self.taskId = taskId
        self.courseId = courseId
        self.action = action
    }
}

/// Body for `POST /api/v1/rag/tasks/delayed`.
public struct RescheduleDelayedTasksRequest: Encodable {
    public let tasks: [DelayedTaskActionDTO]

    public init(tasks: [DelayedTaskActionDTO]) {
        self.tasks = tasks
    }
}