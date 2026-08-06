//
//  SearchTeamsUseCase.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation

public protocol SearchTeamsUseCaseProtocol {
    func execute(query: String) async throws -> [Team]
}

public class SearchTeamsUseCase: SearchTeamsUseCaseProtocol {
    var organizationRepository: OrganizationRepositoryProtocol

    public init(organizationRepository: OrganizationRepositoryProtocol) {
        self.organizationRepository = organizationRepository
    }

    public func execute(query: String) async throws -> [Team] {
        return try await organizationRepository.searchTeams(query: query)
    }
}
