//
//  File.swift
//
//
//  Created by Ahmed Tarek on 22/07/2026.
//

import Foundation
import Common

public enum DashboardEndpoints : EndPoint {
    case dashboard(method: HTTPMethod, path: String)
    case user(method: HTTPMethod, path: String)
    
    public var idToken: String? {
        UserDefaults.standard.string(forKey: "main_token")
    }
    
    public var baseURL: String {
        "https://api-gateway-production-5110.up.railway.app/api/v1/"
    }
    
    public var path: String {
        switch self {
        case .dashboard(_, let pathValue):
            return pathValue
            
        case .user(_, let pathValue):
            return pathValue
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .dashboard(let methodValue, _):
            return methodValue
            
        case .user(let methodValue, _):
            return methodValue
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
        nil
    }
    
}
