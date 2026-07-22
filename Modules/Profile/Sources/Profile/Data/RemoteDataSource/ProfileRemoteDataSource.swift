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
            avatarUrl: "https://plus.unsplash.com/premium_photo-1689977927774-401b12d137d6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bWFuJTIwYXZhdGFyfGVufDB8fDB8fHww",
            stats: mockStats
        )
    }
}
