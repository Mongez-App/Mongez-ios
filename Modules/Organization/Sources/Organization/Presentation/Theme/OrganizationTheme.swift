//
//  OrganizationTheme.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation
import SwiftUI
import Common

public enum OrganizationTheme {
    public enum Colors {
        public static var background: Color {
            Color("background", bundle: .module)
        }

        public static var white100: Color {
            Color("white100", bundle: .module)
        }

        public static var border: Color {
            Color("border", bundle: .module)
        }

        public static var primaryText: Color {
            Color("primaryText", bundle: .module)
        }

        public static var secondaryText: Color {
            Color("secondaryText", bundle: .module)
        }

        public static var subtitleText: Color {
            Color("subtitleText", bundle: .module)
        }

        public static var accent: Color {
            Color("accent", bundle: .module)
        }

        public static var accentBackground: Color {
            Color("accentBackground", bundle: .module)
        }

        public static var pendingBackground: Color {
            Color("pendingBackground", bundle: .module)
        }

        public static var pendingText: Color {
            Color("pendingText", bundle: .module)
        }

        public static var purple: Color {
            Color("purple", bundle: .module)
        }

        public static var green: Color {
            Color("green", bundle: .module)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3:
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }
        self.init(
            .sRGB,
            red: Double(r)   / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: 1
        )
    }
}
