//
//  PreferencesUseCase.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Foundation

public protocol PreferencesUseCaseProtocol {
    func executeFetchPreferences() async throws -> StudyPreferences
    func executeUpdatePreferences(studyDays: [Weekday], dailyStudyHours: Double) async throws -> StudyPreferences
}

public class PreferencesUseCase: PreferencesUseCaseProtocol {
    private let repository: PreferencesRepositoryProtocol

    public init(repository: PreferencesRepositoryProtocol = PreferencesRepository()) {
        self.repository = repository
    }

    public func executeFetchPreferences() async throws -> StudyPreferences {
        try await repository.fetchPreferences()
    }

    public func executeUpdatePreferences(studyDays: [Weekday], dailyStudyHours: Double) async throws -> StudyPreferences {
        try await repository.updatePreferences(studyDays: studyDays, dailyStudyHours: dailyStudyHours)
    }
}