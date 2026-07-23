//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 19/07/2026.
//

import Foundation

protocol GetDashboardDetailsUseCaseProtocol {
    func execute() async throws -> Dashboard
}

class GetDashboardDetailsUseCase : GetDashboardDetailsUseCaseProtocol {
    var dashboardRepository: DashboardRepositoryProtocol
    
    init(dashboardRepository: DashboardRepositoryProtocol) {
        self.dashboardRepository = dashboardRepository
    }
    
    func execute() async throws-> Dashboard {
        return try await dashboardRepository.fetchDashboard()
    }
}
