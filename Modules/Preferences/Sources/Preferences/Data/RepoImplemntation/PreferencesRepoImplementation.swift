//
//  PreferencesRepoImplementation.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Foundation

public class PreferencesRepository: PreferencesRepositoryProtocol {
    private let remote: PreferencesRemoteDataSourceProtocol

    public init(remote: PreferencesRemoteDataSourceProtocol = PreferencesRemoteDataSource()) {
        self.remote = remote
    }

    public func fetchPreferences() async throws -> StudyPreferences {
        let dto = try await remote.fetchPreferences()
        return dto.mapToStudyPreferences()
    }

    public func updatePreferences(studyDays: [Weekday], dailyStudyHours: Double) async throws -> StudyPreferences {
        let dto = try await remote.updatePreferences(
            studyDays: studyDays.map(\.index),
            dailyStudyHours: dailyStudyHours
        )
        return dto.mapToStudyPreferences()
    }
}