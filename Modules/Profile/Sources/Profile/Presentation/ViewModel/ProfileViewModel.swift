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
    @Published var appearanceMode: String = UserDefaults.standard.string(forKey: "user_appearance") ?? "System"
    @Published var selectedLanguage: String = UserDefaults.standard.string(forKey: "selected_language") ?? "EN" {
        didSet {
            UserDefaults.standard.set(selectedLanguage, forKey: "selected_language")
        }
    }
    @Published var showDisableCalendarSyncAlert: Bool = false
    @Published var showLogoutAlert: Bool = false
    @Published var isEditPreferencesPresented: Bool = false
    @Published var isEditProfilePresented: Bool = false
    @Published var dailyStudyHours: Float = 4.0
    @Published var availableDays: Set<Int> = [0, 1, 2, 3, 4]
    @Published var localSelectedImageData: Data? = nil
    @Published var isLoadingPreferencesUpdate: Bool = false
    @Published var showPreferencesUpdateSuccess: Bool = false

    private let getProfileUseCase: GetProfileUseCaseProtocol
    private let getPreferencesUseCase: GetPreferencesUseCaseProtocol
    private let updateProfileUseCase: UpdateProfileUseCaseProtocol
    private let updatePreferencesUseCase: UpdatePreferencesUseCaseProtocol

    init(
        getProfileUseCase: GetProfileUseCaseProtocol,
        getPreferencesUseCase: GetPreferencesUseCaseProtocol,
        updateProfileUseCase: UpdateProfileUseCaseProtocol,
        updatePreferencesUseCase: UpdatePreferencesUseCaseProtocol
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.getPreferencesUseCase = getPreferencesUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.updatePreferencesUseCase = updatePreferencesUseCase
    }

    func loadProfile() {
        Task {
            do {
                async let profileTask = getProfileUseCase.execute()
                async let preferencesTask = getPreferencesUseCase.execute()
                
                let (fetchedProfile, fetchedPreferences) = try await (profileTask, preferencesTask)
                self.profile = fetchedProfile
                
                // Sync UI fields
                if let appearance = fetchedProfile.appearance {
                    // Only override local setting if it's not "System"
                    let localAppearance = UserDefaults.standard.string(forKey: "user_appearance") ?? "System"
                    if localAppearance != "System" {
                        self.appearanceMode = appearance
                        UserDefaults.standard.set(appearance, forKey: "user_appearance")
                    }
                }
                if let language = fetchedProfile.language {
                    self.selectedLanguage = (language.lowercased() == "arabic" || language.lowercased() == "ar") ? "AR" : "EN"
                }
                if let calendarConnected = fetchedProfile.calendarSyncConnected {
                    self.isCalendarSyncEnabled = calendarConnected
                }
                if let dailyHours = fetchedPreferences.dailyStudyHours {
                    self.dailyStudyHours = dailyHours
                }
                if let days = fetchedPreferences.studyDays {
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
                let appearanceString = (appearanceMode == "System") ? "Light Mode" : appearanceMode
                let languageString = (selectedLanguage == "AR") ? "Arabic" : "English"
                let updated = try await updateProfileUseCase.execute(
                    name: currentProfile.name ?? "",
                    avatarUrl: currentProfile.avatarUrl ?? "",
                    appearance: appearanceString,
                    language: languageString,
                    calendarSyncConnected: isCalendarSyncEnabled
                )
                self.profile = currentProfile.merged(with: updated)
            } catch {
                print("Error updating profile: \(error)")
            }
        }
    }

    func updateLanguage(_ lang: String) {
        self.selectedLanguage = lang
        UserDefaults.standard.set(lang.uppercased(), forKey: "selected_language")
        updateProfileOnServer()
    }

    func updateAppearance(_ mode: String) {
        self.appearanceMode = mode
        UserDefaults.standard.set(mode, forKey: "user_appearance")
        if mode != "System" {
            updateProfileOnServer()
        }
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

    func saveEditPreferences(hours: Float, days: Set<Int>) {
        isEditPreferencesPresented = false
        Task {
            isLoadingPreferencesUpdate = true
            guard let currentProfile = self.profile else {
                isLoadingPreferencesUpdate = false
                return
            }
            do {
                let updated = try await updatePreferencesUseCase.execute(
                    dailyStudyHours: hours,
                    availableDays: Array(days)
                )
                self.profile = currentProfile.merged(with: updated)
                self.dailyStudyHours = hours
                self.availableDays = days
                isLoadingPreferencesUpdate = false
                showPreferencesUpdateSuccess = true
            } catch {
                isLoadingPreferencesUpdate = false
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

    func saveEditProfile(name: String, avatarUrl: String?) {
        isEditProfilePresented = false
        guard let currentProfile = profile else { return }
        
        let newAvatarUrl = avatarUrl ?? currentProfile.avatarUrl
        
        if avatarUrl != nil {
            self.localSelectedImageData = nil
        }
       
        let optimisticallyUpdatedProfile = UserProfile(
            userId: currentProfile.userId,
            name: name,
            email: currentProfile.email,
            avatarUrl: newAvatarUrl,
            stats: currentProfile.stats,
            appearance: currentProfile.appearance,
            language: currentProfile.language,
            calendarSyncConnected: currentProfile.calendarSyncConnected
        )
        self.profile = optimisticallyUpdatedProfile
        
        Task {
            do {
                let appearanceString = (self.appearanceMode == "System") ? "Light Mode" : self.appearanceMode
                let languageString = (self.selectedLanguage == "AR") ? "Arabic" : "English"
                
                let serverResponse = try await updateProfileUseCase.execute(
                    name: name,
                    avatarUrl: newAvatarUrl ?? "",
                    appearance: appearanceString,
                    language: languageString,
                    calendarSyncConnected: isCalendarSyncEnabled
                )
                
                self.profile = optimisticallyUpdatedProfile.merged(with: serverResponse)
                
                if !name.isEmpty {
                    UserDefaults.standard.set(name, forKey: "user_display_name")
                }
                
                NotificationCenter.default.post(name: NSNotification.Name("UserDidUpdateProfileNotification"), object: nil, userInfo: ["name": name])
            } catch {
                print("Error saving profile details: \(error)")
                self.profile = currentProfile // Rollback on error
            }
        }
    }

    func cancelEditProfile() {
        isEditProfilePresented = false
    }
    
    func requestLogout() {
        showLogoutAlert = true
    }
    
    func logout() {
      
        UserDefaults.standard.removeObject(forKey: "current_user_id")
        UserDefaults.standard.removeObject(forKey: "main_token")
        
        showLogoutAlert = false
        NotificationCenter.default.post(name: NSNotification.Name("UserDidLogoutNotification"), object: nil)
    }
}
