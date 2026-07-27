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
        public static var purple100 : Color {
            Color("purple100", bundle: .module)
        }
        
        public static var purple200 : Color {
            Color("purple200", bundle: .module)
        }
        
        public static var gray100   : Color{
            Color("gray100", bundle: .module)
        }
        
        public static var gray200   : Color{
            Color("gray200", bundle: .module)
        }
        
        public static var gray300   : Color{
            Color("gray300", bundle: .module)
        }
        
        public static var white100  : Color{
            Color("white100", bundle: .module)
        }
        
        public static var black100  : Color{
            Color("black100", bundle: .module)
        }
        
        public static var green100  : Color{
            Color("green100", bundle: .module)
        }
        
        public static var red100    : Color{
            Color("red100", bundle: .module)
        }
        
        public static var yellow100 : Color{
            Color("yellow100", bundle: .module)
        }
        
        public static var orange100 : Color{
            Color("orange100", bundle: .module)
        }
        
        public static var blue100 : Color{
            Color("blue100", bundle: .module)
        }
        
        public static func changeOpacity (color : Color, opacity:Double)->Color{
            return color.opacity(opacity)
        }
    }
    
    public static func textStyle(size: CGFloat, weight: Font.Weight = .regular) -> Font{
        Font.custom("Arial", size: size).weight(weight)
    }
    
    public enum Spacing{
        public static let xxxSmall : CGFloat  = 4
        public static let xxSmall  : CGFloat  = 8
        public static let xSmall   : CGFloat  = 12
        public static let small    : CGFloat  = 16
        public static let medium   : CGFloat  = 20
        public static let large    : CGFloat  = 24
        public static let xLarge   : CGFloat  = 32
        public static let xxLarge  : CGFloat  = 40
    }
    
    public enum radius {
        public static let small  :  CGFloat = 12
        public static let meduim :  CGFloat = 16
        public static let large :  CGFloat = 24
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

public extension View {
    func appShadow(opacity: Double, radius: CGFloat, y: CGFloat = 0) -> some View {
        self.shadow(
            color: AppTheme.Colors.purple200.opacity(opacity),
            radius: radius,
            x: 0,
            y: y
        )
    }
}

