//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 17/07/2026.
//

import Foundation

struct UserDTO : Codable {
    var userId : String
    var name : String
    var email : String
    var avatarUrl : String
    var stats : Stats
    
    enum CodingKeys : String, CodingKey {
        case userId = "user_id"
        case name
        case email
        case avatarUrl = "avatar_url"
        case stats
    }
}

struct Stats : Codable {
    var totalStudyHours : Float
    var completedTasksCount : Float
    var streakCount : Float
    
    enum CodingKeys : String, CodingKey {
        case totalStudyHours = "total_study_hours"
        case completedTasksCount = "completed_tasks_count"
        case streakCount = "current_streak_days"
    }
}

//
//    func mapToEntity(userDTO: UserDTO) -> User {
//        let user = User(name: userDTO.name,
//            avatarUrl: userDTO.avatar_url,
//            streakCount: userDTO.stats.current_streak_days)
//        
//        return user
//    }

