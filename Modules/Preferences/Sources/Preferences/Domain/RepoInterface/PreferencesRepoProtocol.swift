//
//  PreferencesRepoProtocol.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Foundation

public protocol PreferencesRepositoryProtocol {
    func fetchPreferences() async throws -> StudyPreferences
    func updatePreferences(studyDays: [Weekday], dailyStudyHours: Double) async throws -> StudyPreferences
}