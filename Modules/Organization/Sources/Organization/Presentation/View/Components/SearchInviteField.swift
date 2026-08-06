//
//  SearchInviteField.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

/// Search bar used on the Discover screen to look for teams by name.
struct SearchInviteField: View {
    @Binding var text: String
    let onSubmit: () -> Void

    var body: some View {
        HStack(spacing: AppTheme.Spacing.xSmall) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(OrganizationTheme.Colors.subtitleText)

            TextField("Enter organization name here", text: $text)
                .font(AppTheme.textStyle(size: 14, weight: .regular))
                .foregroundColor(OrganizationTheme.Colors.primaryText)
                .submitLabel(.search)
                .autocorrectionDisabled()
                .onSubmit(onSubmit)
        }
        .padding(.horizontal, AppTheme.Spacing.xSmall)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(OrganizationTheme.Colors.white100)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(OrganizationTheme.Colors.border, lineWidth: 1)
                )
        )
    }
}

#Preview {
    SearchInviteField(text: .constant("")) {}
        .padding()
        .background(OrganizationTheme.Colors.background)
}
