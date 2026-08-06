//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 23/07/2026.
//

import Foundation
import Common

public protocol DashboardRemoteDataSourceProtocol {
    func fetchDashboard() async throws -> DashboardDTO
    func fetchUser() async throws -> UserDTO
    func fetchDelayedTasks() async throws -> DelayedTasksResponseDTO
    func rescheduleDelayedTasks(_ tasks: [DelayedTaskActionDTO]) async throws
}


public class DashboardRemoteDataSource : DashboardRemoteDataSourceProtocol {
    public init() {}
    
    public func fetchDashboard() async throws -> DashboardDTO {
        let endpoint = DashboardEndpoints.dashboard(method: .get, path: "rag/dashboard")
        let fullURL = endpoint.baseURL + endpoint.path
        guard let url = URL(string: fullURL) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let responseStr = String(data: data, encoding: .utf8) ?? "?"
        print("=== DASHBOARD RESPONSE ===")
        print("Status: \(statusCode)")
        print("Body: \(responseStr.prefix(1000))")
        print("==========================")

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "Dashboard", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error \(statusCode): \(responseStr)"])
        }

        // Try wrapped response first
        if let wrapper = try? JSONDecoder().decode(DashboardResponseDTO.self, from: data),
           let dashboard = wrapper.data {
            return dashboard
        }

        // Try direct decode
        return try JSONDecoder().decode(DashboardDTO.self, from: data)
    }
    
    public func fetchUser() async throws -> UserDTO {
        let authResponse = try await NetworkManger.shared.request(
            endpoint: DashboardEndpoints.dashboard(method: .get, path: "auth/student/me"),
            responseType: AuthStudentMeResponseDTO.self
        )
        
        return UserDTO(
            userId: authResponse.data?.uid ?? "",
            name: authResponse.data?.displayName ?? "Student",
            email: authResponse.data?.email ?? "",
            avatarUrl: nil,
            stats: Stats(totalStudyHours: 0, completedTasksCount: 0, streakCount: 0)
        )
    }

    public func fetchDelayedTasks() async throws -> DelayedTasksResponseDTO {
        try await NetworkManger.shared.request(
            endpoint: DashboardEndpoints.delayed(method: .get, path: "rag/tasks/delayed", body: nil),
            responseType: DelayedTasksResponseDTO.self
        )
    }

    public func rescheduleDelayedTasks(_ tasks: [DelayedTaskActionDTO]) async throws {
        let body = try JSONEncoder().encode(RescheduleDelayedTasksRequest(tasks: tasks))
        _ = try await NetworkManger.shared.requestRaw(
            endpoint: DashboardEndpoints.delayed(method: .post, path: "rag/tasks/delayed", body: body)
        )
    }
}
