//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation

protocol ProfileRemoteDataSourceProtocol {
    func getProfile() async throws -> UserProfile
    func updateProfile(name: String, avatarUrl: String, appearance: String, language: String, calendarSyncConnected: Bool) async throws -> UserProfile
    func updatePreferences(dailyStudyHours: Int, availableDays: [String]) async throws -> UserProfile
}

import Common

class ProfileRemoteDataSource: ProfileRemoteDataSourceProtocol {
    func getProfile() async throws -> UserProfile {
        return try await NetworkManger.shared.request(endpoint: ProfileEndpoint.getProfile, responseType: UserProfile.self)
    }
    
    func updateProfile(name: String, avatarUrl: String, appearance: String, language: String, calendarSyncConnected: Bool) async throws -> UserProfile {
        return try await NetworkManger.shared.request(
            endpoint: ProfileEndpoint.updateProfile(name: name, avatarUrl: avatarUrl, appearance: appearance, language: language, calendarSyncConnected: calendarSyncConnected),
            responseType: UserProfile.self
        )
    }
    
    func updatePreferences(dailyStudyHours: Int, availableDays: [String]) async throws -> UserProfile {
        return try await NetworkManger.shared.request(
            endpoint: ProfileEndpoint.updatePreferences(dailyStudyHours: dailyStudyHours, availableDays: availableDays),
            responseType: UserProfile.self
        )
    }
}
