//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation
public protocol AuthRepositoryProtocol {
    func handshake(idToken: String, name: String, avatarUrl: String) async throws -> (user: User, isNewUser: Bool)
    func getMe(idToken: String) async throws -> User
}
