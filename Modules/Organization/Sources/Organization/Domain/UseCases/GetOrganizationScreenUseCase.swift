//
//  GetOrganizationScreenUseCase.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation

public protocol GetOrganizationScreenUseCaseProtocol {
    func execute() async throws -> OrganizationScreen
}

public class GetOrganizationScreenUseCase: GetOrganizationScreenUseCaseProtocol {
    var organizationRepository: OrganizationRepositoryProtocol

    public init(organizationRepository: OrganizationRepositoryProtocol) {
        self.organizationRepository = organizationRepository
    }

    public func execute() async throws -> OrganizationScreen {
        return try await organizationRepository.getOrganizationScreen()
    }
}
