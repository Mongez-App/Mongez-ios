//
//  AuthViewModel.swift
//
//
//  Created by Shady Eldakrory on 18/07/2026.
//

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
            
            let result = try await useCase.executeHandshake(idToken: idToken, isGuest: false)
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
            
            let result = try await useCase.executeHandshake(idToken: firebaseIDToken, isGuest: false)
            self.user = result.user
            onAuthSuccess?(result.isNewUser)
            
        } catch {
            showError(message: mapError(error))
        }
    }
    
    public func continueAsGuest() async {
        showError(message: "Guest login is not available yet")
    }

    private func mapError(_ error: Error) -> String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return "No internet connection. Please check your network."
            case .badServerResponse:
                return "Invalid email or password."
            default:
                return "Something went wrong, please try again."
            }
        }
        return error.localizedDescription
    }
}
