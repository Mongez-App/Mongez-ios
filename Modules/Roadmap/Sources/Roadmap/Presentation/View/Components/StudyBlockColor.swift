//
//  StudyBlockColor.swift
//
//
//  Created by Claude on 23/07/2026.
//

import SwiftUI
import Common

enum StudyBlockColor {
    private static let palette: [Color] = [
        AppTheme.Colors.purple100,
        AppTheme.Colors.blue100,
        AppTheme.Colors.green100,
        AppTheme.Colors.orange100,
        AppTheme.Colors.yellow100
    ]

    /// Deterministically maps an id to a theme color, so the same block
    /// always renders with the same color instead of reshuffling on every redraw.
    static func color(for id: String) -> Color {
        let index = abs(id.hashValue) % palette.count
        return palette[index]
    }
}
