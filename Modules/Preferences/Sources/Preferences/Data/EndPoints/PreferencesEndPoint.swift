//
//  PreferencesEndPoint.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Common
import Foundation

public enum PreferencesEndpoint: EndPoint {
    case updatePreferences(studyDays: [Int], dailyStudyHours: Int)

    public var baseURL: String { "https://course-import-service.vercel.app/api/v1/" }

    public var path: String {
        switch self {
        case .updatePreferences: return "rag/preferences"
        }
    }

    public var method: HTTPMethod { .post }

    public var headers: [String: String]? {
        var headers = ["Content-Type": "application/json", "Accept": "application/json"]
        if let userId = UserDefaults.standard.string(forKey: "current_user_id") {
            headers["x-user-id"] = userId
        }
        return headers
    }

    public var body: Data? {
        switch self {
        case .updatePreferences(let studyDays, let dailyStudyHours):
            return try? JSONEncoder().encode(UpdatePreferencesRequestBody(
                studyDays: studyDays,
                dailyStudyHours: dailyStudyHours
            ))
        }
    }
}

private struct UpdatePreferencesRequestBody: Encodable {
    let studyDays: [Int]
    let dailyStudyHours: Int
}
