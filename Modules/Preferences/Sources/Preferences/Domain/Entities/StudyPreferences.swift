//
//  StudyPreferences.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Foundation

public struct StudyPreferences {
    public let dailyStudyHours: Double
    public let studyDays: [Weekday]

    public init(dailyStudyHours: Double, studyDays: [Weekday]) {
        self.dailyStudyHours = dailyStudyHours
        self.studyDays = studyDays
    }
}