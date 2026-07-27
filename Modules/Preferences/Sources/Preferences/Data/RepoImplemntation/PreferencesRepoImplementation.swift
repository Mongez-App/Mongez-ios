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

    public func updatePreferences(dailyStudyHours: Int, availableDays: [Weekday]) async throws -> StudyPreferences {
        let dto = try await remote.updatePreferences(
            dailyStudyHours: dailyStudyHours,
            availableDays: availableDays.map(\.rawValue)
        )
        return dto.mapToStudyPreferences()
    }
}
