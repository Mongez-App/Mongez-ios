//
//  AuthViewModel.swift
//
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation
import SwiftUI

@MainActor
public final class AuthViewModel: ObservableObject {

    public enum Mode {
        case login
        case register
    }

    @Published public var mode: Mode = .login
    @Published public var name: String = ""
    @Published public var email: String = ""
    @Published public var password: String = ""
    @Published public var confirmPassword: String = ""
    @Published public var isPasswordVisible: Bool = false
    @Published public var isConfirmPasswordVisible: Bool = false
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    @Published public var user: User? = nil

    private let useCase: AuthUseCaseProtocol

    public init(useCase: AuthUseCaseProtocol = AuthUseCase()) {
        self.useCase = useCase
    }

    public func switchMode() {
        mode = (mode == .login) ? .register : .login
        errorMessage = nil
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

    public func submit() async {
        errorMessage = nil

        if let validationError = validate() {
            errorMessage = validationError
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            switch mode {
            case .login:
                user = try await useCase.executeLogin(email: email, password: password)
            case .register:
                user = try await useCase.executeRegister(name: name, email: email, password: password)
            }
        } catch {
            errorMessage = mapError(error)
        }
    }

    public func continueAsGuest() async {
        errorMessage = "Guest login is not available yet"
    }

    private func mapError(_ error: Error) -> String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return "No internet connection"
            case .badServerResponse:
                return "Invalid email or password"
            default:
                return "Something went wrong, please try again"
            }
        }
        return "An unexpected error occurred"
    }
}
