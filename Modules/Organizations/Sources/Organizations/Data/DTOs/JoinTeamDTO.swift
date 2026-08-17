//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 16/08/2026.
//

import Foundation

public struct JoinTeamDTO: Decodable {
    let message: String
    
    public static func mapToEntity(dto: JoinTeamDTO) -> JoinTeamResponse {
        return JoinTeamResponse(message: dto.message)
    }
}
