//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 16/08/2026.
//

import Foundation

public struct OrgTeamsResponse {
    let pendingRequests: [OrgTeam]
    let trendingTeams: [OrgTeam]
}

public struct SearchResponse {
    let data: [OrgTeam]
}

public struct OrgTeam {
    let teamId: String
    let name: String
    let imageUrl: String
    let organizationName: String
    let appliedAt: String
    let status: String
}
