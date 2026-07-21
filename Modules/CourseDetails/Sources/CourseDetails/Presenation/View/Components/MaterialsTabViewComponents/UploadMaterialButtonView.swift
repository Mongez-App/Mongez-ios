//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct UploadMaterialButtonView: View {
    public let action: () -> Void
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Text("+")
                    .font(AppTheme.textStyle(size: 20, weight: .regular))
                Text("Upload Material")
                    .font(AppTheme.textStyle(size: 14, weight: .bold))
            }
            .foregroundColor(AppTheme.Colors.purple200)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.small)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                    .fill(AppTheme.Colors.white100)
                    .appShadow(opacity: 0.6, radius: 3.5)
            )
        }
    }
}
