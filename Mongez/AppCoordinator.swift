//
//  AppCoordinator.swift
//  Mongez
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common
import Authntication
import OnBoarding
import Dashboard
import AIStudyRoom
import Preferences

public enum AppState {
    case onboarding
    case auth
    case preferences
    case dashboard
}

public final class AppCoordinator: ObservableObject, Coordinator {
    public let id = UUID()
    public var childCoordinators: [any Coordinator] = []

    @Published public var state: AppState = .onboarding
    @Published public var onboardingCoordinator: OnboardingCoordinator?
    @Published public var authCoordinator: AuthCoordinator?
    @Published public var preferencesCoordinator: PreferencesCoordinator?
    @Published public var dashboardCoordinator: DashboardCoordinator?
    
    public init() {
        startOnboarding()
    }
    
    public func startOnboarding() {
        let coordinator = OnboardingCoordinator()
        
        coordinator.onFinish = { [weak self] in
            guard let self = self else { return }
            self.removeChild(coordinator)
            self.onboardingCoordinator = nil
            self.startAuth()
        }
        
        addChild(coordinator)
        self.onboardingCoordinator = coordinator
        self.state = .onboarding
    }
    
    public func startAuth() {
        let coordinator = AuthCoordinator()
        
        coordinator.onLoginSuccess = { [weak self] in
            guard let self = self else { return }
            self.removeChild(coordinator)
            self.authCoordinator = nil
            self.startPreferences()
        }

        addChild(coordinator)
        self.authCoordinator = coordinator
        self.state = .auth
    }

    public func startPreferences() {
        let coordinator = PreferencesCoordinator()

        coordinator.onFinish = { [weak self] in
            guard let self = self else { return }
            self.removeChild(coordinator)
            self.preferencesCoordinator = nil
            self.startDashboard()
        }

        addChild(coordinator)
        self.preferencesCoordinator = coordinator
        self.state = .preferences
    }

    public func startDashboard() {
        let coordinator = DashboardCoordinator()
        addChild(coordinator)
        self.dashboardCoordinator = coordinator
        self.state = .dashboard
    }
}
