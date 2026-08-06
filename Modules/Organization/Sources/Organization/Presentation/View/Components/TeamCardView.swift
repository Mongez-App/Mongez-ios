//
//  TeamCardView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

struct TeamCardView: View {
    let team: Team
    let onViewDashboard: () -> Void

    private var logoColor: Color {
        Color(hex: team.logoColorHex)
    }

    private var initials: String {
        let words = team.name.split(separator: " ")
        let letters = words.prefix(2).compactMap { $0.first.map(String.init) }
        return letters.joined().uppercased()
    }

    private var eventText: String {
        team.eventText.isEmpty ? "No events this week" : team.eventText
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            HStack(spacing: AppTheme.Spacing.xSmall) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(logoColor)
                        .frame(width: 40, height: 40)

                    Text(initials)
                        .font(AppTheme.textStyle(size: 16, weight: .semibold))
                        .foregroundColor(OrganizationTheme.Colors.white100)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(team.name)
                        .font(AppTheme.textStyle(size: 16, weight: .medium))
                        .foregroundColor(OrganizationTheme.Colors.primaryText)
                        .lineLimit(1)

                    Text(team.type)
                        .font(AppTheme.textStyle(size: 12, weight: .regular))
                        .foregroundColor(OrganizationTheme.Colors.subtitleText)
                        .lineLimit(1)
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Team Progress")
                        .font(AppTheme.textStyle(size: 11, weight: .regular))
                        .foregroundColor(OrganizationTheme.Colors.subtitleText)

                    Spacer()

                    Text("\(Int(team.completionPercentage))%")
                        .font(AppTheme.textStyle(size: 12, weight: .semibold))
                        .foregroundColor(OrganizationTheme.Colors.accent)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(OrganizationTheme.Colors.border)
                            .frame(height: 8)

                        Capsule()
                            .fill(OrganizationTheme.Colors.accent)
                            .frame(
                                width: geo.size.width * min(max(CGFloat(team.completionPercentage) / 100, 0), 1),
                                height: 8
                            )
                    }
                }
                .frame(height: 8)
            }

            Rectangle()
                .fill(OrganizationTheme.Colors.border)
                .frame(height: 1)

            HStack {
                Text(eventText)
                    .font(AppTheme.textStyle(size: 12, weight: .semibold))
                    .foregroundColor(OrganizationTheme.Colors.accent)
                    .padding(.horizontal, AppTheme.Spacing.xSmall)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(OrganizationTheme.Colors.border)
                    )
                    .lineLimit(1)

                Spacer()

                Button(action: onViewDashboard) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(OrganizationTheme.Colors.accent)
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(AppTheme.Spacing.small)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(OrganizationTheme.Colors.white100)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(OrganizationTheme.Colors.border, lineWidth: 1)
                )
        )
    }
}

#Preview {
    TeamCardView(team: Team.getMockTeams()[0]) {}
        .padding()
        .background(OrganizationTheme.Colors.background)
}
