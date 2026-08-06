//
//  RequestSheetView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

/// Bottom sheet used on the Discover screen to confirm joining a team by
/// entering its invite code.
struct RequestSheetView: View {
    let teamName: String
    let organizationName: String
    var logoColorHex: String = "#10B981"
    @Binding var inviteCode: String
    let canSubmit: Bool
    let isSubmitting: Bool
    let onSubmit: () -> Void
    let onDismiss: () -> Void

    private var initials: String {
        let words = teamName.split(separator: " ")
        let letters = words.prefix(2).compactMap { $0.first.map(String.init) }
        return letters.joined().uppercased()
    }

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(OrganizationTheme.Colors.border)
                .frame(width: 32, height: 4)
                .padding(.top, AppTheme.Spacing.small)
                .padding(.bottom, AppTheme.Spacing.medium)

            VStack(spacing: AppTheme.Spacing.small) {
                ZStack {
                    Circle()
                        .fill(Color(hex: logoColorHex))
                        .frame(width: 88, height: 88)

                    Text(initials)
                        .font(AppTheme.textStyle(size: 24, weight: .semibold))
                        .foregroundColor(OrganizationTheme.Colors.white100)
                }

                VStack(spacing: 4) {
                    Text(teamName)
                        .font(AppTheme.textStyle(size: 20, weight: .medium))
                        .foregroundColor(OrganizationTheme.Colors.primaryText)
                        .multilineTextAlignment(.center)

                    Text(organizationName)
                        .font(AppTheme.textStyle(size: 11, weight: .regular))
                        .foregroundColor(OrganizationTheme.Colors.subtitleText)
                        .multilineTextAlignment(.center)
                }

                Text("Not a member")
                    .font(AppTheme.textStyle(size: 10, weight: .medium))
                    .foregroundColor(OrganizationTheme.Colors.accent)
                    .padding(.horizontal, AppTheme.Spacing.medium)
                    .padding(.vertical, 5)
                    .overlay(
                        Capsule()
                            .stroke(OrganizationTheme.Colors.accent, lineWidth: 1)
                    )
            }
            .padding(.bottom, AppTheme.Spacing.medium)

            HStack(spacing: AppTheme.Spacing.xSmall) {
                TextField("Enter Invite Code or Team ID", text: $inviteCode)
                    .font(AppTheme.textStyle(size: 14, weight: .regular))
                    .foregroundColor(OrganizationTheme.Colors.primaryText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.go)
                    .onSubmit {
                        if canSubmit && !isSubmitting { onSubmit() }
                    }
                    .frame(height: 42)
                    .padding(.horizontal, AppTheme.Spacing.xSmall)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(OrganizationTheme.Colors.white100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(OrganizationTheme.Colors.border, lineWidth: 1)
                            )
                    )

                Button(action: onSubmit) {
                    Group {
                        if isSubmitting {
                            ProgressView()
                                .tint(OrganizationTheme.Colors.white100)
                        } else {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(OrganizationTheme.Colors.white100)
                        }
                    }
                    .frame(width: 42, height: 42)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(OrganizationTheme.Colors.accent)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!canSubmit || isSubmitting)
                .opacity(canSubmit ? 1 : 0.5)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.xLarge)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(OrganizationTheme.Colors.background)
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview {
    RequestSheetView(
        teamName: "Team Name",
        organizationName: "Organization Name",
        inviteCode: .constant(""),
        canSubmit: false,
        isSubmitting: false,
        onSubmit: {},
        onDismiss: {}
    )
}
