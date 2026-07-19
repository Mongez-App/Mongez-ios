//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 17/07/2026.
//

import Foundation

struct User {
    var name : String
    var avatarUrl : String
    var streakCount : Float
}

extension User {
    static func getMockUser() -> User {
        let user = User(name: "Abdullah", avatarUrl: "", streakCount: 12)
        
        return user
    }
}
