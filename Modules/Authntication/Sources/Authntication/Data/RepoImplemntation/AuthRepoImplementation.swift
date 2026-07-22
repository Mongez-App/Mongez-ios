//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

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
    
    public func handshake(idToken: String, isGuest: Bool) async throws -> (user: User, isNewUser: Bool) {
        let dto = try await remote.handshake(idToken: idToken, isGuest: isGuest)
        keychain.saveToken(idToken)
        
        UserDefaults.standard.set(dto.userId, forKey: "current_user_id")
        
        return (dto.mapToUserEntity(firebaseToken: idToken), dto.isNewUser)
    }
}
