//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation

struct UserProfile: Codable {
    let userId: String?
    let name: String?
    let email: String?
    let avatarUrl: String?
    let stats: ProfileStats?
    
    // Optional additional properties from profile update
    let appearance: String?
    let language: String?
    let calendarSyncConnected: Bool?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name
        case email
        case avatarUrl = "avatar_url"
        case stats
        case appearance
        case language
        case calendarSyncConnected = "calendar_sync_connected"
    }
    
    // Merges missing optional fields from a previous profile state
    func merged(with updated: UserProfile) -> UserProfile {
        let mergedStats = self.stats?.merged(with: updated.stats) ?? updated.stats ?? self.stats
        
        return UserProfile(
            userId: updated.userId ?? self.userId,
            name: updated.name ?? self.name,
            email: updated.email ?? self.email,
            avatarUrl: updated.avatarUrl ?? self.avatarUrl,
            stats: mergedStats,
            appearance: updated.appearance ?? self.appearance,
            language: updated.language ?? self.language,
            calendarSyncConnected: updated.calendarSyncConnected ?? self.calendarSyncConnected
        )
    }

    func merged(with preferences: UserPreferences) -> UserProfile {
        let mergedStats = ProfileStats(
            totalStudyHours: self.stats?.totalStudyHours,
            completedTasksCount: self.stats?.completedTasksCount,
            currentStreakDays: self.stats?.currentStreakDays,
            dailyStudyHours: preferences.dailyStudyHours ?? self.stats?.dailyStudyHours,
            availableDays: preferences.availableDays ?? self.stats?.availableDays
        )
        
        return UserProfile(
            userId: self.userId,
            name: self.name,
            email: self.email,
            avatarUrl: self.avatarUrl,
            stats: mergedStats,
            appearance: self.appearance,
            language: self.language,
            calendarSyncConnected: self.calendarSyncConnected
        )
    }
}

struct ProfileStats: Codable {
    let totalStudyHours: Double?
    let completedTasksCount: Int?
    let currentStreakDays: Int?
    
    // Optional additional properties from preferences
    let dailyStudyHours: Int?
    let availableDays: [String]?
    
    enum CodingKeys: String, CodingKey {
        case totalStudyHours = "total_study_hours"
        case completedTasksCount = "completed_tasks_count"
        case currentStreakDays = "current_streak_days"
        case dailyStudyHours = "daily_study_hours"
        case availableDays = "available_days"
    }
    
    func merged(with updated: ProfileStats?) -> ProfileStats {
        guard let updated = updated else { return self }
        return ProfileStats(
            totalStudyHours: updated.totalStudyHours ?? self.totalStudyHours,
            completedTasksCount: updated.completedTasksCount ?? self.completedTasksCount,
            currentStreakDays: updated.currentStreakDays ?? self.currentStreakDays,
            dailyStudyHours: updated.dailyStudyHours ?? self.dailyStudyHours,
            availableDays: updated.availableDays ?? self.availableDays
        )
    }
}

struct UserPreferences: Codable {
    let dailyStudyHours: Int?
    let availableDays: [String]?
    
    enum CodingKeys: String, CodingKey {
        case dailyStudyHours = "daily_study_hours"
        case availableDays = "available_days"
    }
}
