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
}
