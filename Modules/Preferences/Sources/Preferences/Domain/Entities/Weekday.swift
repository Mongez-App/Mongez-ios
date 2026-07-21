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
}
