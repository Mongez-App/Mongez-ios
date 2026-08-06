//
//  EmptyStateView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

/// Shared empty-state illustration + text + optional call-to-action button.
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String?
    var onAction: (() -> Void)?

    var body: some View {
        VStack(spacing: AppTheme.Spacing.small) {
            ZStack {
                Circle()
                    .fill(OrganizationTheme.Colors.accent)
                    .frame(width: 140, height: 140)

                Image(systemName: icon)
                    .font(.system(size: 64, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(spacing: 4) {
                Text(title)
                    .font(AppTheme.textStyle(size: 18, weight: .bold))
                    .foregroundColor(OrganizationTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(AppTheme.textStyle(size: 14, weight: .regular))
                    .foregroundColor(OrganizationTheme.Colors.subtitleText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let actionTitle {
                Button(action: {
                    onAction?()
                }) {
                    Text(actionTitle)
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
                .padding(.top, AppTheme.Spacing.xSmall)
            }
        }
        .padding(.vertical, AppTheme.Spacing.xLarge)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    EmptyStateView(
        icon: "building.2",
        title: "No Teams Yet",
        message: "You haven't joined any teams yet. Search for a code or browse public campus groups.",
        actionTitle: "Join Your First Team"
    ) {}
    .padding()
    .background(OrganizationTheme.Colors.background)
}
