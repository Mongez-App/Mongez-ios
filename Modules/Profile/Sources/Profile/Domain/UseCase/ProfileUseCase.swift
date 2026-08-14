//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation
protocol GetProfileUseCaseProtocol {
    func execute() async throws -> UserProfile
}

class GetProfileUseCase: GetProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> UserProfile {
        return try await repository.fetchProfile()
    }
}

protocol GetPreferencesUseCaseProtocol {
    func execute() async throws -> UserPreferences
}

class GetPreferencesUseCase: GetPreferencesUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> UserPreferences {
        return try await repository.fetchPreferences()
    }
}

protocol UpdateProfileUseCaseProtocol {
    func execute(name: String, avatarUrl: String, appearance: String, language: String, calendarSyncConnected: Bool) async throws -> UserProfile
}

class UpdateProfileUseCase: UpdateProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(name: String, avatarUrl: String, appearance: String, language: String, calendarSyncConnected: Bool) async throws -> UserProfile {
        return try await repository.updateProfile(name: name, avatarUrl: avatarUrl, appearance: appearance, language: language, calendarSyncConnected: calendarSyncConnected)
    }
}

protocol UpdatePreferencesUseCaseProtocol {
    func execute(dailyStudyHours: Int, availableDays: [String]) async throws -> UserPreferences
}

class UpdatePreferencesUseCase: UpdatePreferencesUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(dailyStudyHours: Int, availableDays: [String]) async throws -> UserPreferences {
        return try await repository.updatePreferences(dailyStudyHours: dailyStudyHours, availableDays: availableDays)
    }
}

protocol UpdateCalendarSyncUseCaseProtocol {
    func execute(calendarConnected: Bool, calendarSynced: Bool) async throws -> UserProfile
}

class UpdateCalendarSyncUseCase: UpdateCalendarSyncUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(calendarConnected: Bool, calendarSynced: Bool) async throws -> UserProfile {
        return try await repository.updateCalendarSync(calendarConnected: calendarConnected, calendarSynced: calendarSynced)
    }
}
