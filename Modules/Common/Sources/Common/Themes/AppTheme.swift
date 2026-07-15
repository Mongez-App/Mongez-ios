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
            Color("#4B4DED")
        }
        public static var backGround : Color{
            Color("#F9F9FF")
        }
        public static var primaryText : Color{
            Color("#111827")
        }
        public static var secondoryText : Color{
            Color("#6B7280")
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
