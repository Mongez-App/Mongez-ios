//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 15/08/2026.
//

import Foundation

public struct Event {
    let eventType: String
}

public struct Team {
    let teamId: String
    let name: String
    let organizationName: String
    let imageUrl: String
    let completionPercentage: Double
    let events: [Event]
}
