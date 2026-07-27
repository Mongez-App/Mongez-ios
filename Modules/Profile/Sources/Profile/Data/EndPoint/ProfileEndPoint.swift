//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation
import Common

enum ProfileEndpoint: EndPoint {
    case getProfile
    case updateProfile(name: String, avatarUrl: String, appearance: String, language: String, calendarSyncConnected: Bool)
    case updatePreferences(dailyStudyHours: Int, availableDays: [String])
    
    var baseURL: String {
        return "https://api-gateway-production-3fd0.up.railway.app/api/v1"
    }
    
    var path: String {
        switch self {
        case .getProfile:
            return "/users/me/profile"
        case .updateProfile:
            return "/users/me/profile"
        case .updatePreferences:
            return "/users/me/preferences"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .get
        case .updateProfile:
            return .patch
        case .updatePreferences:
            return .put
        }
    }
    
    var headers: [String : String]? {
        let token = UserDefaults.standard.string(forKey: "main_token") ?? ""
        let lang = UserDefaults.standard.string(forKey: "selected_language")?.lowercased() ?? "en"
        return [
            "Authorization": "Bearer \(token)",
            "Accept-Language": lang,
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var body: Data? {
        switch self {
        case .getProfile:
            return nil
        case .updateProfile(let name, let avatarUrl, let appearance, let language, let calendarSyncConnected):
            let structBody = UpdateProfileBody(
                name: name,
                avatarUrl: avatarUrl,
                appearance: appearance,
                language: language,
                calendarSyncConnected: calendarSyncConnected
            )
            return try? JSONEncoder().encode(structBody)
        case .updatePreferences(let dailyStudyHours, let availableDays):
            let structBody = UpdatePreferencesBody(
                dailyStudyHours: dailyStudyHours,
                availableDays: availableDays
            )
            return try? JSONEncoder().encode(structBody)
        }
    }
}

struct UpdateProfileBody: Encodable {
    let name: String
    let avatarUrl: String
    let appearance: String
    let language: String
    let calendarSyncConnected: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case avatarUrl = "avatar_url"
        case appearance
        case language
        case calendarSyncConnected = "calendar_sync_connected"
    }
}

struct UpdatePreferencesBody: Encodable {
    let dailyStudyHours: Int
    let availableDays: [String]
    
    enum CodingKeys: String, CodingKey {
        case dailyStudyHours = "daily_study_hours"
        case availableDays = "available_days"
    }
}
