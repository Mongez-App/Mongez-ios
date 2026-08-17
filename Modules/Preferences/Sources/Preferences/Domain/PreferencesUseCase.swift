//
//  PreferencesUseCase.swift
//
//
//  Created by Ahmed Mohamed Fathi on 23/07/2026.
//

import Common
import Foundation

public protocol PreferencesUseCaseProtocol {
    func executeUpdatePreferences(dailyStudyHours: Int, availableDays: [Weekday]) async throws -> StudyPreferences
    func executeSyncCalendar() async throws -> Int
}

public class PreferencesUseCase: PreferencesUseCaseProtocol {
    private let repository: PreferencesRepositoryProtocol
    private let calendarSync: CalendarSyncManaging

    public init(
        repository: PreferencesRepositoryProtocol = PreferencesRepository(),
        calendarSync: CalendarSyncManaging = CalendarSyncManager.shared
    ) {
        self.repository = repository
        self.calendarSync = calendarSync
    }

    public func executeUpdatePreferences(dailyStudyHours: Int, availableDays: [Weekday]) async throws -> StudyPreferences {
        try await repository.updatePreferences(dailyStudyHours: dailyStudyHours, availableDays: availableDays)
    }

    public func executeSyncCalendar() async throws -> Int {
        try await calendarSync.requestAccess()
        return try await calendarSync.syncNow()
    }
}
