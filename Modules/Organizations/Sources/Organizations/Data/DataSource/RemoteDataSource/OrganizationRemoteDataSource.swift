//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 15/08/2026.
//

import Foundation
import Common

public protocol OrganizationRemoteDataSourceProtocol {
    func fetchUserTeams() async throws -> [TeamDTO]
    func discoverTeams() async throws -> OrgTeamsResponseDTO
    func joinTeam(inviteCode: String) async throws -> JoinTeamDTO
    func searchTeams(query: String) async throws -> SearchResponseDTO
}


public class OrganizationRemoteDataSource : OrganizationRemoteDataSourceProtocol {
    public init() {}
    
    public func fetchUserTeams() async throws -> [TeamDTO] {
        try await NetworkManger.shared.request(endpoint: OrganizationEndpoints.userTeams(method: .get, path: "/teams"), responseType: [TeamDTO].self)
    }
    
    public func discoverTeams() async throws -> OrgTeamsResponseDTO {
        try await NetworkManger.shared.request(endpoint: OrganizationEndpoints.discover, responseType: OrgTeamsResponseDTO.self)
    }
    
    public func joinTeam(inviteCode: String) async throws -> JoinTeamDTO {
        try await NetworkManger.shared.request(endpoint: OrganizationEndpoints.join(inviteCode: inviteCode), responseType: JoinTeamDTO.self)
    }
    
    public func searchTeams(query: String) async throws -> SearchResponseDTO {
        try await NetworkManger.shared.request(endpoint: OrganizationEndpoints.search(query: query), responseType: SearchResponseDTO.self)
    }
}
