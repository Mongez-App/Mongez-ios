//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation

public protocol AuthRepositoryProtocol {
    /// Authenticates an existing Firebase user against the backend.
    /// On success the returned backend `sessionToken` is persisted securely.
    func login(idToken: String) async throws -> (user: User, isNewUser: Bool)

    /// Registers a new Firebase user against the backend.
    func register(idToken: String) async throws -> (user: User, isNewUser: Bool)

    /// Restores the active session by calling `/me`. Throws when the session is invalid.
    func getMe() async throws -> User

    /// Discards the local session token. No auth header is sent for this call.
    func logout() async throws
}