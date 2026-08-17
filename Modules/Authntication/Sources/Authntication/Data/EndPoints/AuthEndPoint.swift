//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//
import Common
import Foundation
public enum AuthEndpoint: EndPoint {
    case handshake(idToken: String, name: String, appearance: String, language: String)
    case me(idToken: String)
    
    public var baseURL: String { "https://api-gateway-production-5110.up.railway.app/api/v1" }
    
    public var path: String {
        switch self {
        case .handshake:
            return "/auth/handshake"
        case .me:
            return "/auth/me"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .handshake:
            return .post
        case .me:
            return .get
        }
    }
    
    public var headers: [String: String]? {
        let token: String
        switch self {
        case .handshake(let idToken, _, _, _):
            token = idToken
        case .me(let idToken):
            token = idToken
        }
        
        let rawLang = UserDefaults.standard.string(forKey: "selected_language")?.uppercased() ?? "EN"
        let lang = (rawLang == "AR" || rawLang == "ARABIC") ? "ar" : "en"
        
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(token)",
            "Accept-Language": lang
        ]
    }
    
    public var body: Data? {
        switch self {
        case .handshake(_, let name, let appearance, let language):
            let payload: [String: String] = [
                "name": name,
                "appearance": appearance,
                "language": language
            ]
            return try? JSONEncoder().encode(payload)
        case .me:
            return nil
        }
    }
}

