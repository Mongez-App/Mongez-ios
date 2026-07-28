//
//  PreferencesDto.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Foundation

public struct PreferencesDTO: Codable {
    public let dailyStudyHours: Int
    public let studyDays: [Int]

    enum CodingKeys: String, CodingKey {
        case dailyStudyHours
        case studyDays
    }
}

extension PreferencesDTO {
    func mapToStudyPreferences() -> StudyPreferences {
        StudyPreferences(
            dailyStudyHours: dailyStudyHours,
            studyDays: studyDays.compactMap { Weekday(index: $0) }
        )
    }
}
