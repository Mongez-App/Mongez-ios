//
//  AuthViewModel.swift
//
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation
import FirebaseAuth
import Common

@MainActor
public final class AuthViewModel: ObservableObject {

    public enum Mode {
        case login
        case register
    }
    
    public var onAuthSuccess: ((_ isNewUser: Bool) -> Void)?
    
    @Published public var mode: Mode = .login
    @Published public var name: String = ""
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var confirmPassword: String = ""
    @Published public var isPasswordVisible: Bool = false
    @Published public var isConfirmPasswordVisible: Bool = false
    @Published public var isLoading: Bool = false
    @Published public var user: User? = nil
    
    @Published public var showAlert: Bool = false
    @Published public var alertMessage: String = ""

    private let useCase: AuthUseCaseProtocol

    public init(useCase: AuthUseCaseProtocol = AuthUseCase()) {
        self.useCase = useCase
    }

    public func switchMode() {
        mode = (mode == .login) ? .register : .login
        password = ""
        confirmPassword = ""
    }

    private func validate() -> String? {
        if mode == .register && name.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Please enter your name"
        }
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            return "Please enter your email"
        }
        if !email.contains("@") || !email.contains(".") {
            return "Please enter a valid email address"
        }
        if password.isEmpty {
            return "Please enter your password"
        }
        if password.count < 6 {
            return "Password must be at least 6 characters"
        }
        if mode == .register && password != confirmPassword {
            return "Passwords do not match"
        }
        return nil
    }
    
    private func showError(message: String) {
        alertMessage = message
        showAlert = true
    }

    public func submit() async {
        if let validationError = validate() {
            showError(message: validationError)
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let idToken: String
            
            if mode == .login {
                idToken = try await FirebaseEmailAuthService.shared.signIn(email: email, password: password)
            } else {
                idToken = try await FirebaseEmailAuthService.shared.register(name: name, email: email, password: password)
            }
            
            let currentUser = Auth.auth().currentUser
            let displayName = currentUser?.displayName ?? self.name
            
            // Use saved preferences; default to system values on first launch
            let appearance = UserDefaults.standard.string(forKey: "user_appearance") ?? "Light Mode"
            let rawLang = UserDefaults.standard.string(forKey: "selected_language")?.uppercased() ?? "EN"
            let language = (rawLang == "AR" || rawLang == "ARABIC") ? "ar" : "en"
            
            let result = try await useCase.executeHandshake(idToken: idToken, name: displayName, appearance: appearance, language: language)
            self.user = result.user
            onAuthSuccess?(result.isNewUser)
            
        } catch {
            showError(message: mapError(error))
        }
    }

    public func signInWithGoogle() async {
        isLoading = true
        defer { isLoading = false }
 
        do {
            let firebaseIDToken = try await GoogleAuthService.shared.signInAndGetFirebaseIDToken()
            
            let currentUser = Auth.auth().currentUser
            let displayName = currentUser?.displayName ?? ""
            
            // Use saved preferences; default to system values on first launch
            let appearance = UserDefaults.standard.string(forKey: "user_appearance") ?? "Light Mode"
            let rawLang = UserDefaults.standard.string(forKey: "selected_language")?.uppercased() ?? "EN"
            let language = (rawLang == "AR" || rawLang == "ARABIC") ? "ar" : "en"
            
            let result = try await useCase.executeHandshake(idToken: firebaseIDToken, name: displayName, appearance: appearance, language: language)
            self.user = result.user
            onAuthSuccess?(result.isNewUser)
            
        } catch {
            showError(message: mapError(error))
        }
    }
    
    private func mapError(_ error: Error) -> String {
        if let apiError = error as? APIError {
            return apiError.message
        }
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return "No internet connection. Please check your network."
            case .timedOut:
                return "The request timed out. Please try again."
            default:
                return "Something went wrong, please try again."
            }
        }
        return error.localizedDescription
    }
}
