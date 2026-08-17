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
import Common
import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var isLoading: Bool = false
    @Published var isCalendarSyncEnabled: Bool = true
    @Published var isCalendarSynced: Bool = false
    @Published var lastCalendarSyncReadableDate: String = "Never"
    @Published var isManualSyncInProgress: Bool = false
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
    @Published var dailyStudyHours: Int = 4
    @Published var availableDays: Set<String> = ["Mon", "Wed", "Fri"]
    @Published var localSelectedImageData: Data? = nil
    @Published var isPreferencesLoading: Bool = false

    private let getProfileUseCase: GetProfileUseCaseProtocol
    private let getPreferencesUseCase: GetPreferencesUseCaseProtocol
    private let updateProfileUseCase: UpdateProfileUseCaseProtocol
    private let updatePreferencesUseCase: UpdatePreferencesUseCaseProtocol
    private let calendarSync: CalendarSyncManaging

    init(
        getProfileUseCase: GetProfileUseCaseProtocol,
        getPreferencesUseCase: GetPreferencesUseCaseProtocol,
        updateProfileUseCase: UpdateProfileUseCaseProtocol,
        updatePreferencesUseCase: UpdatePreferencesUseCaseProtocol,
        calendarSync: CalendarSyncManaging = CalendarSyncManager.shared
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.getPreferencesUseCase = getPreferencesUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.updatePreferencesUseCase = updatePreferencesUseCase
        self.calendarSync = calendarSync
    }

    func loadProfile() {
        isLoading = true
        Task { @MainActor in
            do {
                async let fetchedProfileTask = getProfileUseCase.execute()
                async let fetchedPreferencesTask = getPreferencesUseCase.execute()
                
                let (fetchedProfile, fetchedPreferences) = try await (fetchedProfileTask, fetchedPreferencesTask)
                
                let mergedProfile = fetchedProfile.merged(with: fetchedPreferences)
                self.profile = mergedProfile
                
                // Sync UI fields
                if let appearance = mergedProfile.appearance {
                    // Only override local setting if it's not "System"
                    let localAppearance = UserDefaults.standard.string(forKey: "user_appearance") ?? "System"
                    if localAppearance != "System" {
                        self.appearanceMode = appearance
                        UserDefaults.standard.set(appearance, forKey: "user_appearance")
                    }
                }
                if let language = fetchedProfile.language {
                    let resolvedLanguage = AppLanguage(backendValue: language)
                    self.selectedLanguage = resolvedLanguage.rawValue
                    LocalizationManager.shared.setLanguage(resolvedLanguage)
                }
                if let calendarConnected = mergedProfile.calendarSyncConnected {
                    self.isCalendarSyncEnabled = calendarConnected
                }
                if let dailyHours = mergedProfile.stats?.dailyStudyHours {
                    self.dailyStudyHours = dailyHours
                }
                if let days = mergedProfile.stats?.availableDays {
                    self.availableDays = Set(days)
                }
                self.isLoading = false
            } catch {
                print("Error loading profile: \(error.localizedDescription)")
                self.isLoading = false
            }
        }
        loadCalendarSyncStatus()
    }

    private func loadCalendarSyncStatus() {
        Task {
            do {
                let status = try await calendarSync.fetchStatus()
                applyCalendarSyncStatus(status)
                if status.calendarConnected {
                    // Resumes the change observer and background refresh scheduling after
                    // an app relaunch, and enforces the 30-day automatic sync guarantee.
                    calendarSync.startContinuousSync(onSyncCompleted: nil)
                }
            } catch {
                print("Error loading calendar sync status: \(error.localizedDescription)")
            }
        }
    }

    private func applyCalendarSyncStatus(_ status: CalendarSyncStatus) {
        isCalendarSyncEnabled = status.calendarConnected
        isCalendarSynced = status.calendarSynced
        lastCalendarSyncReadableDate = status.lastSyncedReadableDate
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
        LocalizationManager.shared.setLanguage(AppLanguage(rawValue: lang.uppercased()) ?? .english)
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
            if newValue {
                enableCalendarSync()
            }
        }
    }

    func confirmDisableCalendarSync() {
        isCalendarSyncEnabled = false
        showDisableCalendarSyncAlert = false
        calendarSync.stopContinuousSync()
        Task {
            do {
                let status = try await calendarSync.updateFlags(calendarConnected: false, calendarSynced: false)
                applyCalendarSyncStatus(status)
            } catch {
                print("Error disabling calendar sync: \(error)")
            }
        }
    }

    private func enableCalendarSync() {
        Task {
            do {
                _ = try await calendarSync.requestAccess()
                calendarSync.startContinuousSync(onSyncCompleted: nil)
                let status = try await calendarSync.updateFlags(calendarConnected: true, calendarSynced: isCalendarSynced)
                applyCalendarSyncStatus(status)
            } catch {
                print("Error enabling calendar sync: \(error)")
                isCalendarSyncEnabled = false
            }
        }
    }

    func manualSyncNow() {
        guard !isManualSyncInProgress else { return }
        isManualSyncInProgress = true
        Task {
            defer { isManualSyncInProgress = false }
            do {
                _ = try await calendarSync.syncNow()
                let status = try await calendarSync.fetchStatus()
                applyCalendarSyncStatus(status)
            } catch {
                print("Error manually syncing calendar: \(error)")
            }
        }
    }

    func cancelDisableCalendarSync() {
        showDisableCalendarSyncAlert = false
    }

    func openEditPreferences() {
        isEditPreferencesPresented = true
        isPreferencesLoading = true
        Task { @MainActor in
            do {
                let fetchedPreferences = try await getPreferencesUseCase.execute()
                if let currentProfile = self.profile {
                    self.profile = currentProfile.merged(with: fetchedPreferences)
                }
                if let dailyHours = fetchedPreferences.dailyStudyHours {
                    self.dailyStudyHours = dailyHours
                }
                if let days = fetchedPreferences.availableDays {
                    self.availableDays = Set(days)
                }
                self.isPreferencesLoading = false
            } catch {
                print("Error fetching preferences: \(error)")
                self.isPreferencesLoading = false
            }
        }
    }

    func saveEditPreferences(hours: Int, days: Set<String>) {
        isEditPreferencesPresented = false
        isLoading = true
        Task { @MainActor in
            guard let currentProfile = self.profile else {
                self.isLoading = false
                return
            }
            do {
                let updatedPreferences = try await updatePreferencesUseCase.execute(
                    dailyStudyHours: hours,
                    availableDays: Array(days)
                )
                self.profile = currentProfile.merged(with: updatedPreferences)
                self.dailyStudyHours = hours
                self.availableDays = days
                self.isLoading = false
            } catch {
                print("Error updating preferences: \(error)")
                self.isLoading = false
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
