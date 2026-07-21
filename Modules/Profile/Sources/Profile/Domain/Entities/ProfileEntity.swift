//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation

struct UserProfile: Codable {
    let userId: String
    let name: String
    let email: String
    let avatarUrl: String
    let stats: ProfileStats
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name
        case email
        case avatarUrl = "avatar_url"
        case stats
    }
}

struct ProfileStats: Codable {
    let totalStudyHours: Int
    let completedTasksCount: Int
    let currentStreakDays: Int
    
    enum CodingKeys: String, CodingKey {
        case totalStudyHours = "total_study_hours"
        case completedTasksCount = "completed_tasks_count"
        case currentStreakDays = "current_streak_days"
    }
}
