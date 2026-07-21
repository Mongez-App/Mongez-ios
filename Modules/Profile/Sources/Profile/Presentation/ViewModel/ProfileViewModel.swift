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
}
