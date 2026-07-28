//
//  PreferencesRepoProtocol.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Foundation

public protocol PreferencesRepositoryProtocol {
    func updatePreferences(studyDays: [Weekday], dailyStudyHours: Int) async throws -> StudyPreferences
}
