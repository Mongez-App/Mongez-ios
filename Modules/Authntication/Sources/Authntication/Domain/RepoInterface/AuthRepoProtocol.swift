//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation
public protocol AuthRepositoryProtocol {
    func handshake(idToken: String, isGuest: Bool) async throws -> (user: User, isNewUser: Bool)
}
