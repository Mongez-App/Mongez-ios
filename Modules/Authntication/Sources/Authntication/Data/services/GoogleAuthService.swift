//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 19/07/2026.
//
import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth

public enum GoogleAuthError: LocalizedError {
    case missingRootViewController
    case missingIDToken
    case cancelled

    public var errorDescription: String? {
        switch self {
        case .missingRootViewController:
            return "Could not find a screen to present Google Sign-In from."
        case .missingIDToken:
            return "Google did not return an ID token."
        case .cancelled:
            return "Google sign-in was cancelled."
        }
    }
}

@MainActor
public final class GoogleAuthService {

    public static let shared = GoogleAuthService()
    private init() {}

    public func signInAndGetFirebaseIDToken() async throws -> String {
        guard let rootViewController = Self.topViewController() else {
            throw GoogleAuthError.missingRootViewController
        }

        let googleResult: GIDSignInResult
        do {
            googleResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        } catch {
            print("🔴 Google Error: \(error)")
            print("🔴 Code: \((error as NSError).code)")
            if (error as NSError).code == GIDSignInError.canceled.rawValue {
                throw GoogleAuthError.cancelled
            }
            throw error
        }

        guard let googleIDToken = googleResult.user.idToken?.tokenString else {
            throw GoogleAuthError.missingIDToken
        }

        let accessToken = googleResult.user.accessToken.tokenString

        let credential = GoogleAuthProvider.credential(
            withIDToken: googleIDToken,
            accessToken: accessToken
        )

        let authResult = try await Auth.auth().signIn(with: credential)

        let firebaseIDToken = try await authResult.user.getIDToken()

        return firebaseIDToken
    }

    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
        try? Auth.auth().signOut()
    }

    private static func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
