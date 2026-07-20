//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//

import Foundation
public struct AuthResponseDTO: Codable {
    public let token: String
    public let userId: String
    public let email: String?
    public let name: String?
    
    enum CodingKeys: String, CodingKey {
        case token, email, name
        case userId = "user_id"
    }
}

extension AuthResponseDTO {
    func mapToUserEntity() -> User {
        return User(
            id: userId,
            name: name ?? "Guest",
            email: email ?? "",
            token: token
        )
    }
}
