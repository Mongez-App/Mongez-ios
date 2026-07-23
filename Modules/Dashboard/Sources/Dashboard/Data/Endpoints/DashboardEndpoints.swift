//
//  File.swift
//
//
//  Created by Ahmed Tarek on 22/07/2026.
//

import Foundation
import Common
import Security

public enum DashboardEndpoints : EndPoint {
    case dashboard(method: HTTPMethod, path: String)
    case user(method: HTTPMethod, path: String)
    
    // will update it to use the UserDefault
    public var idToken: String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "auth_token",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    public var baseURL: String {
        "https://api-gateway-production-3fd0.up.railway.app/api/v1/"
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
