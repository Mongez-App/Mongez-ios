//
//  PreferencesEndPoint.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Common
import Foundation

public enum PreferencesEndpoint: EndPoint {
    case fetchPreferences
    case updatePreferences(studyDays: [Int], dailyStudyHours: Double)

    public var baseURL: String { "https://course-import-service.vercel.app/api/v1/" }

    public var path: String {
        switch self {
        case .fetchPreferences, .updatePreferences:
            return "rag/preferences"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .fetchPreferences:
            return .get
        case .updatePreferences:
            return .post
        }
    }

    public var headers: [String: String]? {
        var headers = ["Content-Type": "application/json", "Accept": "application/json"]
        if let userId = SessionManager.userId {
            headers["x-user-id"] = userId
        }
        if let auth = SessionManager.authorizationHeader {
            headers["Authorization"] = auth["Authorization"]
        }
        return headers
    }

    public var body: Data? {
        switch self {
        case .fetchPreferences:
            return nil
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
    let dailyStudyHours: Double
}