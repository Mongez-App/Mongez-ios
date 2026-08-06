//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation
protocol ProfileRepositoryProtocol {
    func fetchProfile() async throws -> UserProfile
    func fetchPreferences() async throws -> ProfilePreferencesDTO
    func updateProfile(name: String, avatarUrl: String, appearance: String, language: String, calendarSyncConnected: Bool) async throws -> UserProfile
    func updatePreferences(dailyStudyHours: Float, availableDays: [Int]) async throws -> UserProfile
}
