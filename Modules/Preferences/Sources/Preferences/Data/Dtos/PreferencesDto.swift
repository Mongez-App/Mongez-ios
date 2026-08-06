//
//  PreferencesDto.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Foundation

public struct PreferencesDTO: Decodable {
    public let dailyStudyHours: Double
    public let studyDays: [Int]?
    public let availableDays: [String]?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dailyStudyHours = try (try? container.decode(Double.self, forKey: .dailyStudyHours))
            ?? Double(try container.decode(Int.self, forKey: .dailyStudyHours))
        studyDays = try? container.decodeIfPresent([Int].self, forKey: .studyDays)
        availableDays = try? container.decodeIfPresent([String].self, forKey: .availableDays)
    }

    enum CodingKeys: String, CodingKey {
        case dailyStudyHours
        case studyDays
        case availableDays
    }
}

extension PreferencesDTO {
    func mapToStudyPreferences() -> StudyPreferences {
        StudyPreferences(
            dailyStudyHours: dailyStudyHours,
            studyDays: studyDays?.compactMap { Weekday(index: $0) } ?? []
        )
    }
}