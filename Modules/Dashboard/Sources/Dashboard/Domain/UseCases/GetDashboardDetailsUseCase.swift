//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 19/07/2026.
//

import Foundation

public protocol GetDashboardDetailsUseCaseProtocol {
    func execute() async throws -> Dashboard
}

public class GetDashboardDetailsUseCase : GetDashboardDetailsUseCaseProtocol {
    var dashboardRepository: DashboardRepositoryProtocol
    
    public init(dashboardRepository: DashboardRepositoryProtocol) {
        self.dashboardRepository = dashboardRepository
    }
    
    public func execute() async throws-> Dashboard {
        return try await dashboardRepository.fetchDashboard()
    }
}
