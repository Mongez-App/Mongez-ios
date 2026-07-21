//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct CourseHeaderView: View {
    public let title: String
    public let onBack: () -> Void
    public let onOptions: () -> Void
    
    public init(title: String, onBack: @escaping () -> Void = {}, onOptions: @escaping () -> Void = {}) {
        self.title = title
        self.onBack = onBack
        self.onOptions = onOptions
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            HStack {
                Button(action: onBack) {
                    Text("<")
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.purple200)
                }
                Spacer()
                Button(action: onOptions) {
                    Text("...")
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                }
            }
            .padding(.top, AppTheme.Spacing.small)
            
            Text(title)
                .font(AppTheme.textStyle(size: 24, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
        }
        .padding(.horizontal, AppTheme.Spacing.small)
    }
}
