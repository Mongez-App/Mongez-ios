//
//  File.swift
//
//
//  Created by Ahmed Tarek on 15/08/2026.
//

import Foundation

public protocol GetUserTeamsUseCaseProtocol {
    func execute() async throws -> [Team]
}

public class GetUserTeamsUseCase : GetUserTeamsUseCaseProtocol {
    
    
    var organizationRepository: OrganizationRepositoryProtocol
    
    public init(organizationRepository: OrganizationRepositoryProtocol) {
        self.organizationRepository = organizationRepository
        
    }
    
    public func execute() async throws -> [Team] {
        return try await organizationRepository.fetchUserTeams()
    }
    
}
