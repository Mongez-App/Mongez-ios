//
//  GetTeamEventsUseCase.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation

public struct TeamEventsResult: Equatable {
    public var upcoming: [TeamEvent]
    public var past: [TeamEvent]

    public init(upcoming: [TeamEvent], past: [TeamEvent]) {
        self.upcoming = upcoming
        self.past = past
    }
}

public protocol GetTeamEventsUseCaseProtocol {
    func execute(teamId: String) async throws -> TeamEventsResult
}

public class GetTeamEventsUseCase: GetTeamEventsUseCaseProtocol {
    var organizationRepository: OrganizationRepositoryProtocol

    public init(organizationRepository: OrganizationRepositoryProtocol) {
        self.organizationRepository = organizationRepository
    }

    public func execute(teamId: String) async throws -> TeamEventsResult {
        let result = try await organizationRepository.getTeamEvents(teamId: teamId)
        return TeamEventsResult(upcoming: result.upcoming, past: result.past)
    }
}
