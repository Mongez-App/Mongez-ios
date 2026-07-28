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

    public func updatePreferences(studyDays: [Weekday], dailyStudyHours: Int) async throws -> StudyPreferences {
        let dto = try await remote.updatePreferences(
            studyDays: studyDays.map(\.index),
            dailyStudyHours: dailyStudyHours
        )
        return dto.mapToStudyPreferences()
    }
}
