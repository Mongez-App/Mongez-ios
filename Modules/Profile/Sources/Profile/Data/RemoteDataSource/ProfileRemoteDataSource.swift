//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation

protocol ProfileRemoteDataSourceProtocol {
    func getProfile() async throws -> UserProfile
    func fetchPreferences() async throws -> ProfilePreferencesDTO
    func updateProfile(name: String, avatarUrl: String, appearance: String, language: String, calendarSyncConnected: Bool) async throws -> UserProfile
    func updatePreferences(dailyStudyHours: Float, availableDays: [Int]) async throws -> UserProfile
}

import Common

class ProfileRemoteDataSource: ProfileRemoteDataSourceProtocol {
    func getProfile() async throws -> UserProfile {
        let authResponse = try await NetworkManger.shared.request(endpoint: ProfileEndpoint.getProfile, responseType: AuthStudentMeResponse.self)
        let name = authResponse.data?.displayName ?? "Student"
        let email = authResponse.data?.email ?? ""
        let uid = authResponse.data?.uid ?? ""
        
        return UserProfile(
            userId: uid,
            name: name,
            email: email,
            avatarUrl: nil,
            stats: nil,
            appearance: nil,
            language: nil,
            calendarSyncConnected: nil
        )
    }
    
    func fetchPreferences() async throws -> ProfilePreferencesDTO {
        return try await NetworkManger.shared.request(endpoint: ProfileEndpoint.fetchPreferences, responseType: ProfilePreferencesDTO.self)
    }
    
    func updateProfile(name: String, avatarUrl: String, appearance: String, language: String, calendarSyncConnected: Bool) async throws -> UserProfile {
        return try await NetworkManger.shared.request(
            endpoint: ProfileEndpoint.updateProfile(name: name, avatarUrl: avatarUrl, appearance: appearance, language: language, calendarSyncConnected: calendarSyncConnected),
            responseType: UserProfile.self
        )
    }
    
    func updatePreferences(dailyStudyHours: Float, availableDays: [Int]) async throws -> UserProfile {
        return try await NetworkManger.shared.request(
            endpoint: ProfileEndpoint.updatePreferences(dailyStudyHours: dailyStudyHours, availableDays: availableDays),
            responseType: UserProfile.self
        )
    }
}
