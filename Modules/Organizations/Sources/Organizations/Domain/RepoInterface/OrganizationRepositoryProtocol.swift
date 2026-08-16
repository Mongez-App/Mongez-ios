//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 15/08/2026.
//

import Foundation

public protocol OrganizationRepositoryProtocol {
    func fetchUserTeams() async throws -> [Team]
    func discoverTeams() async throws -> OrgTeamsResponse
    func joinTeam(inviteCode: String) async throws -> JoinTeamResponse
    func searchTeams(query: String) async throws -> SearchResponse
}
