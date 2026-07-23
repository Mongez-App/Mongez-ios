//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 23/07/2026.
//

import Foundation


class DashboardRepository : DashboardRepositoryProtocol {
    var remoteDataSource: DashboardRemoteDataSourceProtocol
    
    init(remoteDataSource: DashboardRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchDashboard() async throws -> Dashboard {
        let dashboardDTO = try await remoteDataSource.fetchDashboard()
        
        let dashboard = DashboardDTO.mapToEntity(dashboard: dashboardDTO)
        
        return dashboard
    }
}
