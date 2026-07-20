//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation
public class AuthRepository: AuthRepositoryProtocol {
    public func googleLogin(idToken: String) async throws -> User {
        let dto = try await remote.loginWithGoogle(idToken: idToken)
        keychain.saveToken(dto.token)
        return dto.mapToUserEntity()
    }
    
    private let remote: AuthRemoteDataSourceProtocol
    private let keychain: KeychainManager
 
    public init(remote: AuthRemoteDataSourceProtocol = AuthRemoteDataSource(), keychain: KeychainManager = .shared) {
        self.remote = remote
        self.keychain = keychain
    }
 
    public func login(email: String, password: String, idToken: String) async throws -> User {
        let dto = try await remote.login(email: email, password: password, idToken: idToken)
        keychain.saveToken(dto.token)
        return dto.mapToUserEntity()
    }
 
    public func register(name: String, email: String, password: String, idToken: String) async throws -> User {
        let dto = try await remote.register(name: name, email: email, password: password, idToken: idToken)
        keychain.saveToken(dto.token)
        return dto.mapToUserEntity()
    }

}
