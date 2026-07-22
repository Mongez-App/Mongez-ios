//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation
public struct AuthResponseDTO: Codable {
    public let userId: String
    public let email: String?
    public let name: String?
    public let isNewUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case email,name
        case userId = "user_id"
        case isNewUser = "is_new_user"
    }
}

extension AuthResponseDTO {
    func mapToUserEntity(firebaseToken : String) -> User {
        return User(
            id: userId,
            name: name ?? "Guest",
            email: email ?? "",
            token: firebaseToken
        )
    }
}
