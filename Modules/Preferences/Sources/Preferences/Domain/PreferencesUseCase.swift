//
//  PreferencesUseCase.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Foundation

public protocol PreferencesUseCaseProtocol {
    func executeUpdatePreferences(dailyStudyHours: Int, availableDays: [Weekday]) async throws -> StudyPreferences
}

public class PreferencesUseCase: PreferencesUseCaseProtocol {
    private let repository: PreferencesRepositoryProtocol

    public init(repository: PreferencesRepositoryProtocol = PreferencesRepository()) {
        self.repository = repository
    }

    public func executeUpdatePreferences(dailyStudyHours: Int, availableDays: [Weekday]) async throws -> StudyPreferences {
        try await repository.updatePreferences(dailyStudyHours: dailyStudyHours, availableDays: availableDays)
    }
}
