//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct TeamCourseHeaderView: View {
    public let title: String
    public let onBack: () -> Void
    
    public init(title: String, onBack: @escaping () -> Void = {}) {
        self.title = title
        self.onBack = onBack
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: AppTheme.Spacing.small) {
            Button(action: onBack) {
                Image("back")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
            }
            .padding(.trailing, 2)
            
            Text(title)
                .font(AppTheme.textStyle(size: 24, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
                .lineLimit(1)
            
            Spacer()
            
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.small)
        .padding(.vertical, AppTheme.Spacing.small)
    }
}
