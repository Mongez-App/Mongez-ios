//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Common

public class AuthRepository: AuthRepositoryProtocol {
    private let remote: AuthRemoteDataSourceProtocol
    private let keychain: KeychainManager

    public init(
        remote: AuthRemoteDataSourceProtocol = AuthRemoteDataSource(),
        keychain: KeychainManager = .shared
    ) {
        self.remote = remote
        self.keychain = keychain
    }

    public func login(idToken: String) async throws -> (user: User, isNewUser: Bool) {
        let (dto, statusCode) = try await remote.studentLogin(idToken: idToken)
        return try persistSession(dto: dto, statusCode: statusCode)
    }

    public func register(idToken: String) async throws -> (user: User, isNewUser: Bool) {
        let (dto, statusCode) = try await remote.studentRegister(idToken: idToken)
        return try persistSession(dto: dto, statusCode: statusCode)
    }

    public func getMe() async throws -> User {
        let dto = try await remote.getMe()
        let user = dto.mapToUserEntity(sessionToken: SessionManager.sessionToken ?? "")
        // Keep the locally cached user id in sync with the server response.
        if !dto.resolvedUid.isEmpty {
            SessionManager.userId = dto.resolvedUid
        }
        if !dto.resolvedDisplayName.isEmpty {
            SessionManager.displayName = dto.resolvedDisplayName
        }
        return user
    }

    public func logout() async throws {
        // Best-effort server-side invalidation; the local session must always be discarded.
        try? await remote.logout()
        discardSession()
    }

    // MARK: - Helpers

    /// Extracts the backend JWT from the response, persists it securely and returns
    /// the mapped user. A 201 response means the user was just created.
    private func persistSession(dto: AuthStudentResponseDTO, statusCode: Int) throws -> (user: User, isNewUser: Bool) {
        let sessionToken = dto.resolvedSessionToken
        guard !sessionToken.isEmpty else {
            throw NSError(
                domain: "Auth",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "No session token was returned by the server."]
            )
        }

        keychain.saveToken(sessionToken)
        SessionManager.sessionToken = sessionToken

        if !dto.resolvedUid.isEmpty {
            SessionManager.userId = dto.resolvedUid
        }
        if !dto.resolvedDisplayName.isEmpty {
            SessionManager.displayName = dto.resolvedDisplayName
        }

        let user = dto.mapToUserEntity(sessionToken: sessionToken)
        let isNewUser = (statusCode == 201)
        return (user, isNewUser)
    }

    private func discardSession() {
        keychain.deleteToken()
        SessionManager.clear()
    }
}