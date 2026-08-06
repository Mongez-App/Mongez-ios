//
//  GetDelayedTasksUseCase.swift
//  Dashboard
//
//  Created by Extern Dev
//

import Foundation

public protocol GetDelayedTasksUseCaseProtocol {
    func execute() async throws -> (tasks: [DelayedTask], totalDelayed: Int)
}

public struct GetDelayedTasksUseCase: GetDelayedTasksUseCaseProtocol {
    private let repository: DashboardRepositoryProtocol

    public init(dashboardRepository: DashboardRepositoryProtocol) {
        self.repository = dashboardRepository
    }

    public func execute() async throws -> (tasks: [DelayedTask], totalDelayed: Int) {
        try await repository.fetchDelayedTasks()
    }
}