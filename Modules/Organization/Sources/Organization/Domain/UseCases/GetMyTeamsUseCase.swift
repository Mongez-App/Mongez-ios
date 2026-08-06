//
//  GetMyTeamsUseCase.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation

public protocol GetMyTeamsUseCaseProtocol {
    func execute() async throws -> [Team]
}

public class GetMyTeamsUseCase: GetMyTeamsUseCaseProtocol {
    var organizationRepository: OrganizationRepositoryProtocol

    public init(organizationRepository: OrganizationRepositoryProtocol) {
        self.organizationRepository = organizationRepository
    }

    public func execute() async throws -> [Team] {
        return try await organizationRepository.getMyTeams()
    }
}
