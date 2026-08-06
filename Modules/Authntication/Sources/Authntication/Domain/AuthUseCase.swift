//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation

public protocol AuthUseCaseProtocol {
    func executeLogin(idToken: String) async throws -> (user: User, isNewUser: Bool)
    func executeRegister(idToken: String) async throws -> (user: User, isNewUser: Bool)
    func executeGetMe() async throws -> User
    func executeLogout() async throws
}

public class AuthUseCase: AuthUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    public init(repository: AuthRepositoryProtocol = AuthRepository()) {
        self.repository = repository
    }
    
    public func executeLogin(idToken: String) async throws -> (user: User, isNewUser: Bool) {
        return try await repository.login(idToken: idToken)
    }

    public func executeRegister(idToken: String) async throws -> (user: User, isNewUser: Bool) {
        return try await repository.register(idToken: idToken)
    }

    public func executeGetMe() async throws -> User {
        return try await repository.getMe()
    }

    public func executeLogout() async throws {
        try await repository.logout()
    }
}