//
//  DiscoverCardView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

/// Compact card used on the Discover screen for pending invitations and
/// trending teams. Tapping the card opens the request sheet.
struct DiscoverCardView: View {
    let teamName: String
    let subtitle: String
    var footer: String?
    var logoColorHex: String = "#A855F7"
    let onTap: () -> Void

    private var logoColor: Color {
        Color(hex: logoColorHex)
    }

    private var initials: String {
        let words = teamName.split(separator: " ")
        let letters = words.prefix(2).compactMap { $0.first.map(String.init) }
        return letters.joined().uppercased()
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppTheme.Spacing.xSmall) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(logoColor)
                        .frame(width: 60, height: 60)

                    Text(initials)
                        .font(AppTheme.textStyle(size: 16, weight: .semibold))
                        .foregroundColor(OrganizationTheme.Colors.white100)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(teamName)
                        .font(AppTheme.textStyle(size: 16, weight: .medium))
                        .foregroundColor(OrganizationTheme.Colors.primaryText)
                        .lineLimit(1)

                    HStack(spacing: 8) {
                        Text(subtitle)
                            .font(AppTheme.textStyle(size: 12, weight: .medium))
                            .foregroundColor(OrganizationTheme.Colors.subtitleText)
                            .lineLimit(1)

                        if let footer, !footer.isEmpty {
                            Text(footer)
                                .font(AppTheme.textStyle(size: 12, weight: .regular))
                                .foregroundColor(OrganizationTheme.Colors.subtitleText)
                                .lineLimit(1)
                        }
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(AppTheme.Spacing.xSmall)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(OrganizationTheme.Colors.white100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(OrganizationTheme.Colors.border, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: AppTheme.Spacing.small) {
        DiscoverCardView(
            teamName: "Team Name",
            subtitle: "Organization Name",
            footer: "Applied May 25"
        ) {}
        DiscoverCardView(
            teamName: "Team Name",
            subtitle: "Organization Name"
        ) {}
    }
    .padding()
    .background(OrganizationTheme.Colors.background)
}
