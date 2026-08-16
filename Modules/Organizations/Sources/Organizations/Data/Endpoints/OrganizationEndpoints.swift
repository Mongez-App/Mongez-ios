//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 15/08/2026.
//

import Foundation
import Common

public enum OrganizationEndpoints : EndPoint {
    case userTeams(method: HTTPMethod, path: String)
    case discover
    case join(inviteCode: String)
    case search(query: String)
    
    public var idToken: String? {
        UserDefaults.standard.string(forKey: "main_token")
    }
    
    public var baseURL: String {
        "https://api-gateway-production-5110.up.railway.app/api/v1"
    }
    
    public var path: String {
        switch self {
        case .userTeams(_, let pathValue):
            return pathValue
        case .discover:
            return "/teams/discover"
        case .join:
            return "/teams/join"
        case .search(let query):
            return "/teams/search?q=\(query)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .userTeams(let methodValue, _):
            return methodValue
        case .discover, .search:
            return .get
        case .join:
            return .post
        }
    }
    
    public var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(idToken ?? "")"
        ]
    }
    
    public var body: Data? {
        switch self {
        case .join(let inviteCode):
            let bodyDict = ["inviteCode": inviteCode]
            return try? JSONSerialization.data(withJSONObject: bodyDict)
        default:
            return nil
        }
    }
    
}
