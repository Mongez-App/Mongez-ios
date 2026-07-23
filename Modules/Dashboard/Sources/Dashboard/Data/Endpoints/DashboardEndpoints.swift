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
    
    public var idToken: String? {
        UserDefaults.standard.string(forKey: "current_user_id")
    }
    
    public var baseURL: String {
        "https://api-gateway-production-3fd0.up.railway.app/api/v1"
    }
    
    public var path: String {
        self.path
    }
    
    public var method: HTTPMethod { self.method }
    
    public var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "\(String(describing: idToken))"
        ]
    }
    
    public var body: Data? {
        nil
    }
    
}
