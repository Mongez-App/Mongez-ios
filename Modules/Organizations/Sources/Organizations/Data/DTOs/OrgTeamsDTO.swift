//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 16/08/2026.
//

import Foundation

public struct OrgTeamsResponseDTO: Decodable {
    let pendingRequests: [OrgTeamDTO]
    let trendingTeams: [OrgTeamDTO]
    
    enum CodingKeys: String, CodingKey {
        case pendingRequests = "pending_requests"
        case trendingTeams = "trending_teams"
    }
    
   

    public static func mapToEntity(dto: OrgTeamsResponseDTO) -> OrgTeamsResponse {
        
        let pendingEntities = dto.pendingRequests.map { OrgTeamDTO.mapToEntity(dto: $0) }
        let trendingEntities = dto.trendingTeams.map { OrgTeamDTO.mapToEntity(dto: $0) }
        
        return OrgTeamsResponse(
            pendingRequests: pendingEntities,
            trendingTeams: trendingEntities
        )
    }

}

public struct SearchResponseDTO: Decodable {
    let data: [OrgTeamDTO]
    
    public static func mapToEntity(dto: SearchResponseDTO) -> SearchResponse {
        let data = dto.data.map{OrgTeamDTO.mapToEntity(dto: $0)}
        
        return SearchResponse(data: data)
    }
}

public struct OrgTeamDTO: Decodable {
    let teamId: String
    let name: String
    let imageUrl: String?
    let organizationName: String?
    let appliedAt: String?
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case teamId = "team_id"
        case name
        case imageUrl = "image_url"
        case organizationName = "organization_name"
        case appliedAt = "applied_at"
        case status
    }
    
    public static func mapToEntity(dto: OrgTeamDTO) -> OrgTeam {
        return OrgTeam(
            teamId: dto.teamId,
            name: dto.name,
            imageUrl: dto.imageUrl ?? "",
            organizationName: dto.organizationName ?? "Organization Name",
            appliedAt: dto.appliedAt ?? "",
            status: dto.status
        )
    }
}


