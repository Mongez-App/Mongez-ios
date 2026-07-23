//
//  PreferencesRemoteDataSource.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Common
import Foundation

public protocol PreferencesRemoteDataSourceProtocol {
    func updatePreferences(dailyStudyHours: Int, availableDays: [String], token: String?) async throws -> PreferencesDTO
}

public class PreferencesRemoteDataSource: PreferencesRemoteDataSourceProtocol {
    public init() {}

    public func updatePreferences(dailyStudyHours: Int, availableDays: [String], token: String?) async throws -> PreferencesDTO {
        try await NetworkManger.shared.request(
            endpoint: PreferencesEndpoint.updatePreferences(dailyStudyHours: dailyStudyHours, availableDays: availableDays, token: token),
            responseType: PreferencesDTO.self
        )
    }
}
