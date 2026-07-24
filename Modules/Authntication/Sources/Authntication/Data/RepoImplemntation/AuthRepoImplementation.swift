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
    
    public func handshake(idToken: String, name: String, avatarUrl: String) async throws -> (user: User, isNewUser: Bool) {
        let (dto, statusCode) = try await remote.handshake(idToken: idToken, name: name, avatarUrl: avatarUrl)
        keychain.saveToken(idToken)
        
        UserDefaults.standard.set(dto.userId, forKey: "current_user_id")
        print("\(UserDefaults.standard.string(forKey: "current_user_id") ?? "No id Found")")
        UserDefaults.standard.set(keychain.getToken(), forKey: "main_token")
        print("\(UserDefaults.standard.string(forKey: "main_token") ?? "No id Found")")
        
        let isNewUser = (statusCode == 201)
        return (dto.mapToUserEntity(firebaseToken: idToken), isNewUser)
    }

    public func getMe(idToken: String) async throws -> User {
        let dto = try await remote.getMe(idToken: idToken)
        return dto.mapToUserEntity(firebaseToken: idToken)
    }
}
