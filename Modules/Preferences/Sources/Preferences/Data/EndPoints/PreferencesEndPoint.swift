//
//  PreferencesEndPoint.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Common
import Foundation

public enum PreferencesEndpoint: EndPoint {
    case updatePreferences(dailyStudyHours: Int, availableDays: [String], token: String?)

    public var baseURL: String { "https://api.smartstudy.app/v3" }

    public var path: String {
        switch self {
        case .updatePreferences: return "/users/me/preferences"
        }
    }

    public var method: HTTPMethod { .put }

    public var headers: [String: String]? {
        var headers = ["Content-Type": "application/json", "Accept": "application/json"]
        switch self {
        case .updatePreferences(_, _, let token):
            if let token {
                headers["Authorization"] = "Bearer \(token)"
            }
        }
        return headers
    }

    public var body: Data? {
        switch self {
        case .updatePreferences(let dailyStudyHours, let availableDays, _):
            return try? JSONEncoder().encode(UpdatePreferencesRequestBody(
                dailyStudyHours: dailyStudyHours,
                availableDays: availableDays
            ))
        }
    }
}

private struct UpdatePreferencesRequestBody: Encodable {
    let dailyStudyHours: Int
    let availableDays: [String]

    enum CodingKeys: String, CodingKey {
        case dailyStudyHours = "daily_study_hours"
        case availableDays = "available_days"
    }
}
