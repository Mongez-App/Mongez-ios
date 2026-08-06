//
//  RescheduleDelayedTasksUseCase.swift
//  Dashboard
//
//  Created by Extern Dev
//

import Foundation

public protocol RescheduleDelayedTasksUseCaseProtocol {
    /// Applies an action to a set of delayed tasks (batched to at most 100 per request).
    func execute(tasks: [(taskId: String, courseId: String?, action: DelayedAction)]) async throws
}

public struct RescheduleDelayedTasksUseCase: RescheduleDelayedTasksUseCaseProtocol {
    private let repository: DashboardRepositoryProtocol

    public init(dashboardRepository: DashboardRepositoryProtocol) {
        self.repository = dashboardRepository
    }

    public func execute(tasks: [(taskId: String, courseId: String?, action: DelayedAction)]) async throws {
        // Backend contract: up to 100 tasks per request.
        let maxBatchSize = 100
        let batches = stride(from: 0, to: tasks.count, by: maxBatchSize).map {
            Array(tasks[$0..<min($0 + maxBatchSize, tasks.count)])
        }

        for batch in batches {
            let dto = batch.map {
                DelayedTaskActionDTO(taskId: $0.taskId, courseId: $0.courseId, action: $0.action.rawValue)
            }
            try await repository.rescheduleDelayedTasks(tasks: dto)
        }
    }
}