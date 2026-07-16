//
//  File.swift
//  Common
//
//  Created by shady ramadan on 15/07/2026.
//

import Foundation
import SwiftUI

public enum AppTheme{
    
    public enum Colors {
        public static var primaryColor : Color {
            Color(hex: "#4B4DED")
        }
        public static var backGround : Color{
            Color(hex: "#F9F9FF")
        }
        public static var primaryText : Color{
            Color(hex: "#111827")
        }
        public static var secondoryText : Color{
            Color(hex: "#6B7280")
        }
      
        public static var BtnText : Color{
            Color(.white)
        }
        public static func changeOpacity (color : Color,opacity:Double)->Color{
            return color.opacity(opacity)
        }
    }
    public enum Typography{
        
    }
    public enum Spacing{
        public static let xxSmall: CGFloat = 2
        public static let xSmall: CGFloat  = 4
        public static let small: CGFloat   = 8
        public static let medium: CGFloat  = 16
        public static let large: CGFloat   = 24
        public static let xLarge: CGFloat  = 32
        public static let xxLarge: CGFloat = 48
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
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: 1
        )
    }
}
