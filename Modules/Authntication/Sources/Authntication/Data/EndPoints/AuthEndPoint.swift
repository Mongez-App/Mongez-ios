//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//
import Common
import Foundation
public enum AuthEndpoint:EndPoint {
    case login(email: String, password: String,idToken: String)
    case register(name: String, email: String, password: String,idToken: String)
    case guestLogin
    case googleLogin(idToken : String)
    
    public var baseURL: String { "https://api.smartstudy.app/v3" }
    
    public var path: String {
        switch self {
        case .login: return "/auth/login"
        case .register: return "/auth/register"
        case .guestLogin: return "/auth/guest"
        case .googleLogin: return "/auth/google"
        }
    }
    
    public var method: HTTPMethod { .post }
    
    public var headers: [String: String]? {
        ["Content-Type": "application/json", "Accept": "application/json"]
    }
    
    public var body: Data? {
        switch self {
        case .login(let email, let password, let idToken):
                    return try? JSONEncoder().encode([
                        "email": email,
                        "password": password,
                        "id_token": idToken
                    ])
                case .register(let name, let email, let password, let idToken):
                    return try? JSONEncoder().encode([
                        "name": name,
                        "email": email,
                        "password": password,
                        "id_token": idToken
                    ])
                case .guestLogin:
                    return try? JSONEncoder().encode(["is_guest": true])
                case .googleLogin(let idToken):

                    return try? JSONEncoder().encode(["id_token": idToken])
                }
    }
}
