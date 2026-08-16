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
}
