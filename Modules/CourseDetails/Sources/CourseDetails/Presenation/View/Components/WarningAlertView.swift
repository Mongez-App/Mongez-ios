//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/08/2026.
//

import Foundation
import SwiftUI
import Common

public struct WarningAlertView: View {
    public let title: String
    public let subtitle: String
    public let primaryButtonText: String
    public let onPrimaryAction: () -> Void
    public let onCancel: () -> Void
    
    public init(title: String, subtitle: String, primaryButtonText: String = "Delete", onPrimaryAction: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.primaryButtonText = primaryButtonText
        self.onPrimaryAction = onPrimaryAction
        self.onCancel = onCancel
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.large) {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.red100, opacity: 0.15))
                        .frame(width: 64, height: 64)
                    
                    Image("warning")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .padding(.top, AppTheme.Spacing.small)
                
                VStack(spacing: AppTheme.Spacing.xxSmall) {
                    Text(title)
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                    
                    Text(subtitle)
                        .font(AppTheme.textStyle(size: 14, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray300)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.Spacing.small)
                }
                
                VStack(spacing: AppTheme.Spacing.small) {
                    Button(action: onPrimaryAction) {
                        Text(primaryButtonText)
                            .font(AppTheme.textStyle(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.white100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .fill(AppTheme.Colors.red100)
                            )
                    }
                    
                    Button(action: onCancel) {
                        Text("Cancel")
                            .font(AppTheme.textStyle(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.black100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(AppTheme.Spacing.large)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.large)
                    .fill(AppTheme.Colors.white100)
                    .appShadow(opacity: 0.7, radius: 12.5)
            )
            .padding(.horizontal, AppTheme.Spacing.xLarge)
        }
    }
}
