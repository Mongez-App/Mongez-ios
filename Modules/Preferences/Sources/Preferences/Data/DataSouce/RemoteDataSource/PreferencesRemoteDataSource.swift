//
//  PreferencesRemoteDataSource.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Common
import Foundation

public protocol PreferencesRemoteDataSourceProtocol {
    func updatePreferences(studyDays: [Int], dailyStudyHours: Int) async throws -> PreferencesDTO
}

public class PreferencesRemoteDataSource: PreferencesRemoteDataSourceProtocol {
    public init() {}

    public func updatePreferences(studyDays: [Int], dailyStudyHours: Int) async throws -> PreferencesDTO {
        try await NetworkManger.shared.request(
            endpoint: PreferencesEndpoint.updatePreferences(studyDays: studyDays, dailyStudyHours: dailyStudyHours),
            responseType: PreferencesDTO.self
        )
    }
}
