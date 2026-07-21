//
//  File.swift
//
//
//  Created by Ahmed Tarek on 21/07/2026.
//

import Foundation

public enum AppTab: Int, CaseIterable {
    case dashboard
    case courses
    case roadmap
    case profile
    
    public var iconName: String {
        switch self {
        case .dashboard:
            return "house.fill"
        case .courses:
            return "house.fill"
        case .roadmap:
            return "house.fill"
        case .profile:
            return "person.fill"
        }
    }
}
