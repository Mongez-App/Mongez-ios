//
//  ValidationAlertView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

/// Custom confirmation alert shown after sending a join request.
struct ValidationAlertView: View {
    let title: String
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: AppTheme.Spacing.large) {
                VStack(spacing: AppTheme.Spacing.small) {
                    Text(title)
                        .font(AppTheme.textStyle(size: 20, weight: .semibold))
                        .foregroundColor(OrganizationTheme.Colors.primaryText)
                        .multilineTextAlignment(.center)

                    Text(message)
                        .font(AppTheme.textStyle(size: 14, weight: .regular))
                        .foregroundColor(OrganizationTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity)

                Button(action: onDismiss) {
                    Text("OK")
                        .font(AppTheme.textStyle(size: 14, weight: .medium))
                        .foregroundColor(OrganizationTheme.Colors.white100)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(OrganizationTheme.Colors.accent)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(AppTheme.Spacing.large)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(OrganizationTheme.Colors.white100)
            )
            .padding(.horizontal, AppTheme.Spacing.large)
        }
    }
}

#Preview {
    ValidationAlertView(
        title: "Confirmation",
        message: "Your request has been sent for Mobile Native"
    ) {}
}
