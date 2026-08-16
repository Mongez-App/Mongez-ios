//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 15/08/2026.
//

import Foundation

public struct EventDTO: Decodable {
    let eventType: String
    
    enum CodingKeys: String, CodingKey {
        case eventType = "event_type"
    }
}

public struct TeamDTO: Decodable {
    let teamId: String
    let name: String
    let organizationName: String
    let imageUrl: String?
    let completionPercentage: Double
    let events: [EventDTO]
    
    enum CodingKeys: String, CodingKey {
        case teamId = "team_id"
        case name
        case organizationName = "organization_name"
        case imageUrl = "image_url"
        case completionPercentage = "completion_percentage"
        case events
    }
    

    public static func mapToEntity(dto: TeamDTO) -> Team {
        let eventEntities = dto.events.map { eventDTO in
            Event(eventType: eventDTO.eventType)
        }
        
        return Team(
            teamId: dto.teamId,
            name: dto.name,
            organizationName: dto.organizationName,
            imageUrl: dto.imageUrl ?? "",
            completionPercentage: dto.completionPercentage,
            events: eventEntities
        )
    }
}
