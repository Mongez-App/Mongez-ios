//
//  AppCoordinator.swift
//  Mongez
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import Combine
import SwiftUI
import Common
import Authntication
import OnBoarding
import Dashboard
import AIStudyRoom
import Preferences
import Courses
import Swinject

public enum AppState {
    case splash
    case onboarding
    case auth
    case preferences
    case dashboard
    case courses
}

@MainActor
public final class AppCoordinator: ObservableObject, Coordinator {
    public let id = UUID()
    public var childCoordinators: [any Coordinator] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Swinject Container
    public let container: Container = {
        let container = Container()
        let assembler = Assembler([CoursesAssembly()], container: container)
        return container
    }()
    
    /// Resolves a CoursesViewModel from the Swinject container
    public func makeCoursesViewModel() -> CoursesViewModel {
        return container.resolve(CoursesViewModel.self)!
    }

    @Published public var state: AppState = .splash
    @Published public var onboardingCoordinator: OnboardingCoordinator?
    @Published public var authCoordinator: AuthCoordinator?
    @Published public var preferencesCoordinator: PreferencesCoordinator?
    @Published public var dashboardCoordinator: DashboardCoordinator?
    @Published public var coursesCoordinator: CoursesCoordinator?
    
    public init() {
        setupLogoutListener()
        setupProfileUpdateListener()
    }
    
    public func finishSplash() {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        let isLoggedIn = SessionManager.hasActiveSession
        
        if isLoggedIn {
            restoreSession()
        } else if hasCompletedOnboarding {
            startAuth()
        } else {
            startOnboarding()
        }
    }

    /// Verifies the stored session token against `GET /api/v1/auth/student/me`
    /// on app launch. An invalid/expired session (401/403) returns the user to login.
    private func restoreSession() {
        Task { @MainActor in
            do {
                _ = try await AuthUseCase().executeGetMe()
                startDashboard()
            } catch {
                if let apiError = error as? APIError, [401, 403].contains(apiError.statusCode) {
                    // Session token is no longer valid.
                    SessionManager.clear()
                    startAuth()
                } else {
                    // Network/other failure: proceed with the cached session.
                    startDashboard()
                }
            }
        }
    }
    
    private func setupLogoutListener() {
        NotificationCenter.default.publisher(for: NSNotification.Name("UserDidLogoutNotification"))
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.handleLogout()
            }
            .store(in: &cancellables)
     }
     
     private func setupProfileUpdateListener() {
         NotificationCenter.default.publisher(for: NSNotification.Name("UserDidUpdateProfileNotification"))
             .receive(on: RunLoop.main)
             .sink { notification in
                 if let name = notification.userInfo?["name"] as? String {
                     Task {
                         do {
                             try await FirebaseEmailAuthService.shared.updateProfile(name: name)
                             print("Firebase Auth profile updated with name: \(name)")
                         } catch {
                             print("Failed to update Firebase Auth profile name: \(error)")
                         }
                     }
                 }
             }
             .store(in: &cancellables)
     }
    
    private func handleLogout() {
        GoogleAuthService.shared.signOut()

        // Inform the backend that the session should be revoked, then discard
        // the session token locally. This is best-effort and never blocks logout.
        Task {
            try? await AuthUseCase().executeLogout()
        }

        // Clear all child coordinators
        childCoordinators.removeAll()
        dashboardCoordinator = nil
        coursesCoordinator = nil
        preferencesCoordinator = nil
        onboardingCoordinator = nil
        
        startAuth()
    }
    
    public func startOnboarding() {
        let coordinator = OnboardingCoordinator()
        
        coordinator.onFinish = { [weak self] in
            guard let self = self else { return }
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
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
            self.startDashboard()
        }
        
        coordinator.onRegisterSuccess = { [weak self] in
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
    
    public func startCourses() {
        let coordinator = CoursesCoordinator()
        addChild(coordinator)
        self.coursesCoordinator = coordinator
        self.state = .courses
    }
}
