//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation
public protocol AuthRepositoryProtocol {
    func login(email: String, password: String,idToken: String) async throws -> User
    func register(name: String, email: String, password: String,idToken: String) async throws -> User
    func googleLogin(idToken: String)async throws -> User
}
