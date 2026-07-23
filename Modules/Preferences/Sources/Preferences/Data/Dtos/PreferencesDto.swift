//
//  PreferencesDto.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Foundation

public struct PreferencesDTO: Codable {
    public let dailyStudyHours: Int
    public let availableDays: [String]

    enum CodingKeys: String, CodingKey {
        case dailyStudyHours = "daily_study_hours"
        case availableDays = "available_days"
    }
}

extension PreferencesDTO {
    func mapToStudyPreferences() -> StudyPreferences {
        StudyPreferences(
            dailyStudyHours: dailyStudyHours,
            availableDays: availableDays.compactMap { Weekday(rawValue: $0) }
        )
    }
}
