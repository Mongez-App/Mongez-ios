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
    case organization
    case roadmap
    case profile
    
    public var iconName: String {
        switch self {
        case .dashboard:
            return "home"
        case .courses:
            return "courses"
        case .organization:
            return "organization"
        case .roadmap:
            return "roadmap"
        case .profile:
            return "profile"
        }
    }
    
    /// When non-nil, the tab is rendered with an SF Symbol instead of an asset image.
    public var systemImageName: String? {
        switch self {
        case .organization:
            return "building.2"
        default:
            return nil
        }
    }
}
