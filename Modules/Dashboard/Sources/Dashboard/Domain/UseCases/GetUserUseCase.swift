//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 19/07/2026.
//

import Foundation

public protocol GetUserUseCaseProtocol {
    func execute() async throws -> User
}

public class GetUserUseCase : GetUserUseCaseProtocol {
    var dashboardRepository: DashboardRepositoryProtocol
    
    public init(dashboardRepository: DashboardRepositoryProtocol) {
        self.dashboardRepository = dashboardRepository
    }
    
    public func execute() async throws-> User {
        return try await dashboardRepository.fetchUser()
    }
}
