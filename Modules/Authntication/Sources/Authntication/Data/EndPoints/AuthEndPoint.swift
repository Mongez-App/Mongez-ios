//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//
import Common
import Foundation

public enum AuthEndpoint: EndPoint {
    case studentLogin(idToken: String)
    case studentRegister(idToken: String)
    case studentMe
    case studentLogout

    public var baseURL: String { "https://course-import-service.vercel.app/api/v1" }

    public var path: String {
        switch self {
        case .studentLogin:
            return "/auth/student/login"
        case .studentRegister:
            return "/auth/student/register"
        case .studentMe:
            return "/auth/student/me"
        case .studentLogout:
            return "/auth/student/logout"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .studentLogin, .studentRegister, .studentLogout:
            return .post
        case .studentMe:
            return .get
        }
    }

    public var headers: [String: String]? {
        let lang = UserDefaults.standard.string(forKey: "selected_language")?.lowercased() ?? "en"

        var headers: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Accept-Language": lang
        ]

        switch self {
        case .studentMe:
            // The session token (backend-issued JWT) validates the active session.
            if let auth = SessionManager.authorizationHeader {
                headers["Authorization"] = auth["Authorization"] ?? ""
            }
        case .studentLogin, .studentRegister, .studentLogout:
            break
        }

        return headers
    }

    public var body: Data? {
        switch self {
        case .studentLogin(let idToken):
            return AuthEndpoint.idTokenBody(idToken)
        case .studentRegister(let idToken):
            return AuthEndpoint.idTokenBody(idToken)
        case .studentMe, .studentLogout:
            return nil
        }
    }

    private static func idTokenBody(_ idToken: String) -> Data? {
        let payload: [String: String] = ["idToken": idToken]
        return try? JSONEncoder().encode(payload)
    }
}
