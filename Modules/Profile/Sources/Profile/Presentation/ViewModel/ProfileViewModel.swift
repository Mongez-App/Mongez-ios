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
    @Published var selectedLanguage: String = UserDefaults.standard.string(forKey: "selected_language") ?? "EN" {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selected_language")
        }
    }
    @Published var showDisableCalendarSyncAlert: Bool = false
    @Published var isEditPreferencesPresented: Bool = false
    @Published var isEditProfilePresented: Bool = false
    @Published var dailyStudyHours: Int = 4
    @Published var availableDays: Set<String> = ["Mon", "Wed", "Fri"]
    @Published var localSelectedImageData: Data? = nil

    private let getProfileUseCase: GetProfileUseCaseProtocol
    private let updateProfileUseCase: UpdateProfileUseCaseProtocol
    private let updatePreferencesUseCase: UpdatePreferencesUseCaseProtocol

    init(
        getProfileUseCase: GetProfileUseCaseProtocol,
        updateProfileUseCase: UpdateProfileUseCaseProtocol,
        updatePreferencesUseCase: UpdatePreferencesUseCaseProtocol
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.updatePreferencesUseCase = updatePreferencesUseCase
    }

    func loadProfile() {
        Task {
            do {
                let fetchedProfile = try await getProfileUseCase.execute()
                self.profile = fetchedProfile
                
                // Sync UI fields
                if let appearance = fetchedProfile.appearance {
                    self.isDarkModeEnabled = (appearance.lowercased() == "dark mode")
                }
                if let language = fetchedProfile.language {
                    self.selectedLanguage = (language.lowercased() == "arabic" || language.lowercased() == "ar") ? "AR" : "EN"
                }
                if let calendarConnected = fetchedProfile.calendarSyncConnected {
                    self.isCalendarSyncEnabled = calendarConnected
                }
                if let dailyHours = fetchedProfile.stats.dailyStudyHours {
                    self.dailyStudyHours = dailyHours
                }
                if let days = fetchedProfile.stats.availableDays {
                    self.availableDays = Set(days)
                }
            } catch {
                print("Error loading profile: \(error.localizedDescription)")
            }
        }
    }

    private func updateProfileOnServer() {
        guard let currentProfile = profile else { return }
        Task {
            do {
                let appearanceString = isDarkModeEnabled ? "Dark Mode" : "Light Mode"
                let languageString = (selectedLanguage == "AR") ? "Arabic" : "English"
                let updated = try await updateProfileUseCase.execute(
                    name: currentProfile.name,
                    avatarUrl: currentProfile.avatarUrl,
                    appearance: appearanceString,
                    language: languageString,
                    calendarSyncConnected: isCalendarSyncEnabled
                )
                self.profile = updated
            } catch {
                print("Error updating profile: \(error)")
            }
        }
    }

    func updateLanguage(_ lang: String) {
        self.selectedLanguage = lang
        updateProfileOnServer()
    }

    func updateDarkMode(_ isDark: Bool) {
        self.isDarkModeEnabled = isDark
        updateProfileOnServer()
    }

    func requestCalendarSyncChange(to newValue: Bool) {
        if isCalendarSyncEnabled && newValue == false {
            showDisableCalendarSyncAlert = true
        } else {
            isCalendarSyncEnabled = newValue
            updateProfileOnServer()
        }
    }

    func confirmDisableCalendarSync() {
        isCalendarSyncEnabled = false
        showDisableCalendarSyncAlert = false
        updateProfileOnServer()
    }

    func cancelDisableCalendarSync() {
        showDisableCalendarSyncAlert = false
    }

    func openEditPreferences() {
        isEditPreferencesPresented = true
    }

    func saveEditPreferences(hours: Int, days: Set<String>) {
        isEditPreferencesPresented = false
        Task {
            do {
                let updated = try await updatePreferencesUseCase.execute(
                    dailyStudyHours: hours,
                    availableDays: Array(days)
                )
                self.profile = updated
                self.dailyStudyHours = hours
                self.availableDays = days
            } catch {
                print("Error updating preferences: \(error)")
            }
        }
    }

    func cancelEditPreferences() {
        isEditPreferencesPresented = false
    }

    func openEditProfile() {
        isEditProfilePresented = true
    }

    func saveEditProfile(name: String, imageData: Data?) {
        isEditProfilePresented = false
        guard let currentProfile = profile else { return }
        // Store picked image data locally for immediate display
        if let data = imageData {
            self.localSelectedImageData = data
        }
        Task {
            do {
                let appearanceString = isDarkModeEnabled ? "Dark Mode" : "Light Mode"
                let languageString = (selectedLanguage == "AR") ? "Arabic" : "English"
                // Keep existing avatarUrl when no new image is chosen
                let avatarUrl = currentProfile.avatarUrl
                let updated = try await updateProfileUseCase.execute(
                    name: name,
                    avatarUrl: avatarUrl,
                    appearance: appearanceString,
                    language: languageString,
                    calendarSyncConnected: isCalendarSyncEnabled
                )
                self.profile = updated
            } catch {
                print("Error saving profile details: \(error)")
            }
        }
    }

    func cancelEditProfile() {
        isEditProfilePresented = false
    }
}
