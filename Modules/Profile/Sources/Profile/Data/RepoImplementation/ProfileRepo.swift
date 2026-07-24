//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation

class ProfileRepository: ProfileRepositoryProtocol {
    private let remoteDataSource: ProfileRemoteDataSourceProtocol
    
    init(remoteDataSource: ProfileRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchProfile() async throws -> UserProfile {
        return try await remoteDataSource.getProfile()
    }

    func updateProfile(name: String, avatarUrl: String, appearance: String, language: String, calendarSyncConnected: Bool) async throws -> UserProfile {
        return try await remoteDataSource.updateProfile(name: name, avatarUrl: avatarUrl, appearance: appearance, language: language, calendarSyncConnected: calendarSyncConnected)
    }

    func updatePreferences(dailyStudyHours: Int, availableDays: [String]) async throws -> UserProfile {
        return try await remoteDataSource.updatePreferences(dailyStudyHours: dailyStudyHours, availableDays: availableDays)
    }
}
