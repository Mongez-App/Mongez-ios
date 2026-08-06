//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation

// MARK: - Student auth response

/// Decodes the student login/register/me responses. The backend wraps the payload
/// inside a `data` object (`{ "data": { "sessionToken": "...", "user": {...} } }`),
/// but some endpoints may return the fields at the top level, so both shapes are
/// tolerated and merged.
public struct AuthStudentResponseDTO: Decodable {
    public let success: Bool?
    public let message: String?

    private let nested: AuthStudentDataDTO?
    private let sessionToken: String?
    private let uid: String?
    private let email: String?
    private let displayName: String?
    private let name: String?
    private let avatarUrl: String?
    private let userId: String?

    enum CodingKeys: String, CodingKey {
        case success, message
        case nested = "data"
        case sessionToken, uid, email, displayName, name, avatarUrl
        case userId = "user_id"
    }

    /// The backend-issued JWT used for all subsequent authenticated requests.
    public var resolvedSessionToken: String {
        nested?.sessionToken ?? sessionToken ?? ""
    }

    public var resolvedUid: String {
        nested?.uid ?? nested?.user?.uid ?? uid ?? userId ?? ""
    }

    public var resolvedEmail: String {
        nested?.email ?? nested?.user?.email ?? email ?? ""
    }

    public var resolvedDisplayName: String {
        nested?.displayName ?? nested?.user?.displayName ?? nested?.user?.name ?? displayName ?? name ?? ""
    }

    public var resolvedAvatarUrl: String? {
        nested?.avatarUrl ?? nested?.user?.avatarUrl ?? avatarUrl
    }
}

public struct AuthStudentDataDTO: Decodable {
    public let sessionToken: String?
    public let uid: String?
    public let email: String?
    public let displayName: String?
    public let name: String?
    public let avatarUrl: String?
    public let user: AuthStudentUserDTO?
}

public struct AuthStudentUserDTO: Decodable {
    public let uid: String?
    public let email: String?
    public let displayName: String?
    public let name: String?
    public let avatarUrl: String?
    public let userId: String?

    enum CodingKeys: String, CodingKey {
        case uid, email, displayName, name, avatarUrl
        case userId = "user_id"
    }
}

extension AuthStudentResponseDTO {
    func mapToUserEntity(sessionToken: String) -> User {
        return User(
            id: resolvedUid,
            name: resolvedDisplayName.isEmpty ? "Student" : resolvedDisplayName,
            email: resolvedEmail,
            token: sessionToken,
            avatarUrl: resolvedAvatarUrl,
            appearance: nil,
            language: nil,
            calendarSyncConnected: false
        )
    }
}

// MARK: - Legacy profile response

public struct AuthResponseDTO: Codable {
    public let userId: String
    public let email: String?
    public let name: String?
    public let avatarUrl: String?
    public let appearance: String?
    public let language: String?
    public let calendarSyncConnected: Bool?
    public let stats: AuthStatsDTO?
    
    enum CodingKeys: String, CodingKey {
        case email, name, appearance, language, stats
        case userId = "user_id"
        case avatarUrl = "avatar_url"
        case calendarSyncConnected = "calendar_sync_connected"
    }
}

public struct AuthStatsDTO: Codable {
    public let totalStudyHours: Double
    public let completedTasksCount: Int
    public let currentStreakDays: Int
    
    enum CodingKeys: String, CodingKey {
        case totalStudyHours = "total_study_hours"
        case completedTasksCount = "completed_tasks_count"
        case currentStreakDays = "current_streak_days"
    }
}

extension AuthResponseDTO {
    func mapToUserEntity(firebaseToken: String) -> User {
        return User(
            id: userId,
            name: name ?? "Guest",
            email: email ?? "",
            token: firebaseToken,
            avatarUrl: avatarUrl,
            appearance: appearance,
            language: language,
            calendarSyncConnected: calendarSyncConnected ?? false
        )
    }
}
