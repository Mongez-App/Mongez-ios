//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation

protocol ProfileRemoteDataSourceProtocol {
    func getProfile() async throws -> UserProfile
}

class ProfileRemoteDataSource: ProfileRemoteDataSourceProtocol {
    func getProfile() async throws -> UserProfile {
        let mockStats = ProfileStats(
            totalStudyHours: 145,
            completedTasksCount: 382,
            currentStreakDays: 14
        )
        
        return UserProfile(
            userId: "usr_firebase_99812",
            name: "Abdullah Mohamed",
            email: "abdullah@example.com",
            avatarUrl: "https://cdn.smartstudy.app/avatars/usr_99812.jpg",
            stats: mockStats
        )
    }
}
