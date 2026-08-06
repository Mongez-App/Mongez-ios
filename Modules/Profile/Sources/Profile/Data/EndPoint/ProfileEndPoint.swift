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
    case fetchPreferences
    case updateProfile(name: String, avatarUrl: String, appearance: String, language: String, calendarSyncConnected: Bool)
    case updatePreferences(dailyStudyHours: Float, availableDays: [Int])
    
    var baseURL: String {
        return "https://course-import-service.vercel.app/api/v1"
    }
    
    var path: String {
        switch self {
        case .getProfile:
            return "/auth/student/me"
        case .fetchPreferences:
            return "/rag/preferences"
        case .updateProfile:
            return "/users/me/profile"
        case .updatePreferences:
            return "/rag/preferences"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getProfile, .fetchPreferences:
            return .get
        case .updateProfile:
            return .patch
        case .updatePreferences:
            return .put
        }
    }
    
    var headers: [String : String]? {
        let token = SessionManager.sessionToken ?? UserDefaults.standard.string(forKey: "main_token") ?? ""
        let lang = UserDefaults.standard.string(forKey: "selected_language")?.lowercased() ?? "en"
        var h = [
            "Authorization": "Bearer \(token)",
            "Accept-Language": lang,
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        if let userId = SessionManager.userId {
            h["x-user-id"] = userId
            h["X-User-Id"] = userId
        }
        return h
    }
    
    var body: Data? {
        switch self {
        case .getProfile, .fetchPreferences:
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
                studyDays: availableDays,
                dailyStudyHours: dailyStudyHours
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
    let studyDays: [Int]
    let dailyStudyHours: Float
    
    enum CodingKeys: String, CodingKey {
        case studyDays = "studyDays"
        case dailyStudyHours = "dailyStudyHours"
    }
}
