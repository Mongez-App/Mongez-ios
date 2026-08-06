//
//  OrganizationEndpoints.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation
import Common

public enum OrganizationEndpoints: EndPoint {
    case myTeams
    case myCourses
    case joinTeam(inviteCode: String)
    case searchTeams(query: String)
    case teamScreen
    case teamCourses(teamId: String)
    case teamEvents(teamId: String)

    public var baseURL: String {
        return "https://course-import-service.vercel.app/api/v1/"
    }

    public var path: String {
        switch self {
        case .myTeams:
            return "teams"
        case .myCourses:
            return "rag/courses"
        case .joinTeam:
            return "teams/join"
        case .searchTeams(let query):
            let encodedQuery = query
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            return "teams/search?inviteCode=\(encodedQuery)"
        case .teamScreen:
            return "teams/screen"
        case .teamCourses(let teamId):
            return "teams/\(teamId)/courses"
        case .teamEvents(let teamId):
            return "teams/\(teamId)/events"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .joinTeam:
            return .post
        case .myTeams, .myCourses, .searchTeams, .teamScreen, .teamCourses, .teamEvents:
            return .get
        }
    }

    public var headers: [String: String]? {
        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]

        if let token = UserDefaults.standard.string(forKey: "main_token") {
            headers["Authorization"] = "Bearer \(token)"
        }

        if let userId = UserDefaults.standard.string(forKey: "current_user_id"), !userId.isEmpty {
            headers["x-user-id"] = userId
        }

        if let displayName = UserDefaults.standard.string(forKey: "user_display_name"), !displayName.isEmpty {
            headers["x-user-display-name"] = displayName
        }

        return headers
    }

    public var body: Data? {
        switch self {
        case .joinTeam(let inviteCode):
            let payload: [String: String] = ["inviteCode": inviteCode]
            return try? JSONEncoder().encode(payload)
        case .myTeams, .myCourses, .searchTeams, .teamScreen, .teamCourses, .teamEvents:
            return nil
        }
    }
}
