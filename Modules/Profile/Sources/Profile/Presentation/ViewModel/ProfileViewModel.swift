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
                if let dailyHours = fetchedProfile.stats?.dailyStudyHours {
                    self.dailyStudyHours = dailyHours
                }
                if let days = fetchedProfile.stats?.availableDays {
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

    func saveEditPreferences(hours: Int, days: Set<String>) {
        isEditPreferencesPresented = false
        Task {
            guard let currentProfile = self.profile else { return }
            do {
                let updated = try await updatePreferencesUseCase.execute(
                    dailyStudyHours: hours,
                    availableDays: Array(days)
                )
                self.profile = currentProfile.merged(with: updated)
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
    
    func logout() {
      
        UserDefaults.standard.removeObject(forKey: "current_user_id")
        UserDefaults.standard.removeObject(forKey: "main_token")
        
        
        NotificationCenter.default.post(name: NSNotification.Name("UserDidLogoutNotification"), object: nil)
    }
}
