//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 17/07/2026.
//

import Foundation

public struct User {
    var name : String
    var avatarUrl : String
    var streakCount : Int
}

extension User {
    static func getMockUser() -> User {
        let user = User(name: "Abdullah", avatarUrl: "https://plus.unsplash.com/premium_photo-1689977927774-401b12d137d6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bWFuJTIwYXZhdGFyfGVufDB8fDB8fHww", streakCount: 12)
        
        return user
    }
}
