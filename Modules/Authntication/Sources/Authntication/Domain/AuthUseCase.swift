//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation

public protocol AuthUseCaseProtocol {
    func executeHandshake(idToken: String, name: String, appearance: String, language: String) async throws -> (user: User, isNewUser: Bool)
    func executeGetMe(idToken: String) async throws -> User
}

public class AuthUseCase: AuthUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    public init(repository: AuthRepositoryProtocol = AuthRepository()) {
        self.repository = repository
    }
    
    public func executeHandshake(idToken: String, name: String, appearance: String, language: String) async throws -> (user: User, isNewUser: Bool) {
        return try await repository.handshake(idToken: idToken, name: name, appearance: appearance, language: language)
    }

    public func executeGetMe(idToken: String) async throws -> User {
        return try await repository.getMe(idToken: idToken)
    }
}
