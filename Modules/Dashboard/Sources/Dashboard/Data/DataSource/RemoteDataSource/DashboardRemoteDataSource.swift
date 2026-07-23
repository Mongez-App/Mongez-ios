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
}


public class DashboardRemoteDataSource : DashboardRemoteDataSourceProtocol {
    
    public init() {}
    
    public func fetchDashboard() async throws -> DashboardDTO {
        try await NetworkManger.shared.request(endpoint: DashboardEndpoints.dashboard(method: .post, path: "/home/dashboard"),
                                               responseType: DashboardDTO.self)
    }
}
