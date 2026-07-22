//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

//
//  File.swift
//
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Combine
import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var isCalendarSyncEnabled: Bool = true
    @Published var isDarkModeEnabled: Bool = false
    @Published var selectedLanguage: String = "EN"
    @Published var showDisableCalendarSyncAlert: Bool = false
    @Published var isEditPreferencesPresented: Bool = false
    @Published var dailyStudyHours: Int = 4
    @Published var availableDays: Set<String> = ["Mon", "Wed", "Fri"]

    private let getProfileUseCase: GetProfileUseCaseProtocol

    init(getProfileUseCase: GetProfileUseCaseProtocol) {
        self.getProfileUseCase = getProfileUseCase
    }

    func loadProfile() {
        Task {
            do {
                self.profile = try await getProfileUseCase.execute()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func requestCalendarSyncChange(to newValue: Bool) {
        if isCalendarSyncEnabled && newValue == false {
            showDisableCalendarSyncAlert = true
        } else {
            isCalendarSyncEnabled = newValue
        
        }
    }

    func confirmDisableCalendarSync() {
        isCalendarSyncEnabled = false
        showDisableCalendarSyncAlert = false
    
    }

    func cancelDisableCalendarSync() {
        showDisableCalendarSyncAlert = false
    }


    func openEditPreferences() {
        isEditPreferencesPresented = true
    }

    func saveEditPreferences(hours: Int, days: Set<String>) {
        dailyStudyHours = hours
        availableDays = days
        isEditPreferencesPresented = false
        
    }

    func cancelEditPreferences() {
        isEditPreferencesPresented = false
    }
}
