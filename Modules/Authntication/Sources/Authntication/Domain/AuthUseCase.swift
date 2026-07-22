//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation

public protocol AuthUseCaseProtocol {
    func executeHandshake(idToken: String, isGuest: Bool) async throws -> (user: User, isNewUser: Bool)
}

public class AuthUseCase: AuthUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    public init(repository: AuthRepositoryProtocol = AuthRepository()) {
        self.repository = repository
    }
    
    public func executeHandshake(idToken: String, isGuest: Bool) async throws -> (user: User, isNewUser: Bool) {
        return try await repository.handshake(idToken: idToken, isGuest: isGuest)
    }
}
