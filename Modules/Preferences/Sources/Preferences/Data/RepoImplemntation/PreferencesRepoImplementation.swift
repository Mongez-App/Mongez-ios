//
//  PreferencesRepoImplementation.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Common
import Foundation

public class PreferencesRepository: PreferencesRepositoryProtocol {
    private let remote: PreferencesRemoteDataSourceProtocol
    private let keychain: KeychainManager

    public init(remote: PreferencesRemoteDataSourceProtocol = PreferencesRemoteDataSource(), keychain: KeychainManager = .shared) {
        self.remote = remote
        self.keychain = keychain
    }

    public func updatePreferences(dailyStudyHours: Int, availableDays: [Weekday]) async throws -> StudyPreferences {
        let dto = try await remote.updatePreferences(
            dailyStudyHours: dailyStudyHours,
            availableDays: availableDays.map(\.rawValue),
            token: keychain.getToken()
        )
        return dto.mapToStudyPreferences()
    }
}
