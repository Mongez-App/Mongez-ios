//
//  Weekday.swift
//
//
//  Created by Ahmed Mohamed Fathi on 18/07/2026.
//

import Foundation

public enum Weekday: String, CaseIterable, Identifiable {
    case sunday = "Sun"
    case monday = "Mon"
    case tuesday = "Tue"
    case wednesday = "Wed"
    case thursday = "Thu"
    case friday = "Fri"
    case saturday = "Sat"

    public var id: String { rawValue }

    public var index: Int {
        switch self {
        case .sunday: return 0
        case .monday: return 1
        case .tuesday: return 2
        case .wednesday: return 3
        case .thursday: return 4
        case .friday: return 5
        case .saturday: return 6
        }
    }

    public init?(index: Int) {
        switch index {
        case 0: self = .sunday
        case 1: self = .monday
        case 2: self = .tuesday
        case 3: self = .wednesday
        case 4: self = .thursday
        case 5: self = .friday
        case 6: self = .saturday
        default: return nil
        }
    }
}
