//
//  PreferencesRemoteDataSource.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Common
import Foundation

public protocol PreferencesRemoteDataSourceProtocol {
    func fetchPreferences() async throws -> PreferencesDTO
    func updatePreferences(studyDays: [Int], dailyStudyHours: Double) async throws -> PreferencesDTO
}

public class PreferencesRemoteDataSource: PreferencesRemoteDataSourceProtocol {
    public init() {}

    public func fetchPreferences() async throws -> PreferencesDTO {
        try await NetworkManger.shared.request(
            endpoint: PreferencesEndpoint.fetchPreferences,
            responseType: PreferencesDTO.self
        )
    }

    public func updatePreferences(studyDays: [Int], dailyStudyHours: Double) async throws -> PreferencesDTO {
        try await NetworkManger.shared.request(
            endpoint: PreferencesEndpoint.updatePreferences(studyDays: studyDays, dailyStudyHours: dailyStudyHours),
            responseType: PreferencesDTO.self
        )
    }
}