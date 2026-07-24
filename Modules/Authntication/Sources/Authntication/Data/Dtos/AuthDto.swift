//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation
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
