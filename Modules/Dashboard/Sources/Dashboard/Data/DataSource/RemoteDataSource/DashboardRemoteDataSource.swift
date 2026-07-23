//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 23/07/2026.
//

import Foundation
import Common

protocol DashboardRemoteDataSourceProtocol {
    func fetchDashboard() async throws -> DashboardDTO
}


class DashboardRemoteDataSource : DashboardRemoteDataSourceProtocol {
    
    func fetchDashboard() async throws -> DashboardDTO {
        try await NetworkManger.shared.request(endpoint: DashboardEndpoints.dashboard(method: .post, path: "/home/dashboard"),
                                               responseType: DashboardDTO.self)
    }
}
