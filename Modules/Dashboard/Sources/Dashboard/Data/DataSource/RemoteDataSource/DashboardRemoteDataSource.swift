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
}


public class DashboardRemoteDataSource : DashboardRemoteDataSourceProtocol {
    public init() {}
    
    public func fetchDashboard() async throws -> DashboardDTO {
        try await NetworkManger.shared.request(endpoint: DashboardEndpoints.dashboard(method: .get, path: "home/dashboard"),
                                               responseType: DashboardDTO.self)
    }
    
    public func fetchUser() async throws -> UserDTO {
        try await NetworkManger.shared.request(endpoint: DashboardEndpoints.user(method: .get, path: "users/me/profile"),
                                               responseType: UserDTO.self)
    }
}
