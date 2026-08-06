//
//  JoinTeamUseCase.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation

public protocol JoinTeamUseCaseProtocol {
    func execute(code: String) async throws
}

public class JoinTeamUseCase: JoinTeamUseCaseProtocol {
    var organizationRepository: OrganizationRepositoryProtocol

    public init(organizationRepository: OrganizationRepositoryProtocol) {
        self.organizationRepository = organizationRepository
    }

    public func execute(code: String) async throws {
        return try await organizationRepository.joinTeam(code: code)
    }
}
