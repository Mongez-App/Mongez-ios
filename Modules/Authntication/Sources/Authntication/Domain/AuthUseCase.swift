//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation
public protocol AuthUseCaseProtocol {
    func executeLogin(email: String, password: String) async throws -> User
    func executeRegister(name: String, email: String, password: String) async throws -> User
}

public class AuthUseCase: AuthUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    
    public init(repository: AuthRepositoryProtocol = AuthRepository()) {
        self.repository = repository
    }
    
    public func executeLogin(email: String, password: String) async throws -> User {
        return try await repository.login(email: email, password: password)
    }
    
    public func executeRegister(name: String, email: String, password: String) async throws -> User {
        return try await repository.register(name: name, email: email, password: password)
    }
}
