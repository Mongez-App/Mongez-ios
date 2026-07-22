//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//
import Common
import Foundation
public enum AuthEndpoint:EndPoint {
    case handshake(idToken: String, isGuest: Bool)
    public var baseURL: String { "https://api-gateway-production-3fd0.up.railway.app/api/v1" }
    
    public var path: String {
       return "/auth/handshake"
    }
    
    public var method: HTTPMethod { .post }
    
    public var headers: [String: String]? {
            switch self {
            case .handshake(let idToken, _):
                return [
                    "Content-Type": "application/json",
                    "Accept": "application/json",
                    "Authorization": "Bearer \(idToken)"
                ]
            }
        }
    
    public var body: Data? {
            switch self {
            case .handshake(_, let isGuest):
                return try? JSONEncoder().encode(["is_guest": isGuest])
            }
        }
    }
