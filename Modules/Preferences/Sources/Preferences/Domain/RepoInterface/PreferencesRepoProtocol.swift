//
//  PreferencesRepoProtocol.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Foundation

public protocol PreferencesRepositoryProtocol {
    func updatePreferences(dailyStudyHours: Int, availableDays: [Weekday]) async throws -> StudyPreferences
}
