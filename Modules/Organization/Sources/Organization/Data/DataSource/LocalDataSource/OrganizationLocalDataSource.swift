//
//  OrganizationLocalDataSource.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation

public protocol OrganizationLocalDataSourceProtocol {
    func fetchMyTeams() async throws -> [TeamDTO]
    func fetchOrganizationScreen() async throws -> OrganizationScreenDTO
}

public class OrganizationLocalDataSource: OrganizationLocalDataSourceProtocol {
    public init() {}

    public func fetchMyTeams() async throws -> [TeamDTO] {
        Team.getMockTeams().map { team in
            TeamDTO(
                teamId: team.id,
                orgName: team.type,
                teamName: team.name,
                memberCount: team.memberCount
            )
        }
    }

    public func fetchOrganizationScreen() async throws -> OrganizationScreenDTO {
        let teams = Team.getMockTeams().map { team in
            TeamDTO(
                teamId: team.id,
                orgName: team.type,
                teamName: team.name,
                memberCount: team.memberCount
            )
        }
        let pendingInvites = PendingRequest.getMockPendingRequests().map { request in
            PendingRequestDTO(
                teamName: request.teamName,
                status: request.status
            )
        }
        return OrganizationScreenDTO(
            teams: teams,
            pendingInvites: pendingInvites,
            stats: TeamScreenStatsDTO(totalTeams: teams.count, pendingInvites: pendingInvites.count)
        )
    }
}
