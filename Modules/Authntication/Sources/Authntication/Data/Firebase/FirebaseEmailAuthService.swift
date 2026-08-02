//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 19/07/2026.
//

import Foundation
import FirebaseAuth
 
public final class FirebaseEmailAuthService {
 
    public static let shared = FirebaseEmailAuthService()
    private init() {}
 
    public func signIn(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return try await result.user.getIDToken()
    }
 
    public func register(name: String, email: String, password: String) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
 
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
 
        return try await result.user.getIDToken()
    }
    
    public func updateProfile(name: String) async throws {
        guard let user = Auth.auth().currentUser else { return }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
    }
}
