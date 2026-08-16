//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 15/08/2026.
//

import Foundation

public class OrganizationRepository : OrganizationRepositoryProtocol {
    
    
    var remoteDataSource: OrganizationRemoteDataSourceProtocol
    
    public init(remoteDataSource: OrganizationRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func fetchUserTeams() async throws -> [Team] {
        let teamsDTO = try await remoteDataSource.fetchUserTeams()
        
        let teams = teamsDTO.map{TeamDTO.mapToEntity(dto: $0)}
        
        return teams
    }
    
    public func discoverTeams() async throws -> OrgTeamsResponse {
        let dto = try await remoteDataSource.discoverTeams()
        return OrgTeamsResponseDTO.mapToEntity(dto: dto)
    }
    
    public func joinTeam(inviteCode: String) async throws -> JoinTeamResponse {
        let dto = try await remoteDataSource.joinTeam(inviteCode: inviteCode)
        return JoinTeamDTO.mapToEntity(dto: dto)
    }
    
    public func searchTeams(query: String) async throws -> SearchResponse {
        let dto = try await remoteDataSource.searchTeams(query: query)
        return SearchResponseDTO.mapToEntity(dto: dto)
    }
}
