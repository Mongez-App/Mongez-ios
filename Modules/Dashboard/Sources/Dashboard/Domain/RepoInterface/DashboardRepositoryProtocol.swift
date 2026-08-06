//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 23/07/2026.
//

import Foundation

public protocol DashboardRepositoryProtocol {
    func fetchDashboard() async throws -> Dashboard
    func fetchUser() async throws -> User
    func fetchDelayedTasks() async throws -> (tasks: [DelayedTask], totalDelayed: Int)
    func rescheduleDelayedTasks(tasks: [DelayedTaskActionDTO]) async throws
}