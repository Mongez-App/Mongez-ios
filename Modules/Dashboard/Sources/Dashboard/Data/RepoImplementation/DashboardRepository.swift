//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 23/07/2026.
//

import Foundation


public class DashboardRepository : DashboardRepositoryProtocol {
    var remoteDataSource: DashboardRemoteDataSourceProtocol
    
    public init(remoteDataSource: DashboardRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func fetchDashboard() async throws -> Dashboard {
        let dashboardDTO = try await remoteDataSource.fetchDashboard()
        
        let dashboard = DashboardDTO.mapToEntity(dashboard: dashboardDTO)
        
        return dashboard
    }
    
    public func fetchUser() async throws -> User {
        let userDTO = try await remoteDataSource.fetchUser()
        
        let user = UserDTO.mapToEntity(user: userDTO)
        
        return user
    }

    public func fetchDelayedTasks() async throws -> (tasks: [DelayedTask], totalDelayed: Int) {
        let dto = try await remoteDataSource.fetchDelayedTasks()
        let tasks = dto.tasks.compactMap { $0.toDomain() }
        return (tasks: tasks, totalDelayed: dto.totalDelayed)
    }

    public func rescheduleDelayedTasks(tasks: [DelayedTaskActionDTO]) async throws {
        try await remoteDataSource.rescheduleDelayedTasks(tasks)
    }
}