//
//  EventCardView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

/// Compact event card shown inside a team's Events tab.
struct EventCardView: View {
    let event: TeamEvent

    var body: some View {
        HStack(spacing: AppTheme.Spacing.xSmall) {
            VStack(alignment: .leading, spacing: 2) {
                if !event.teamName.isEmpty {
                    Text(event.teamName)
                        .font(AppTheme.textStyle(size: 10, weight: .medium))
                        .foregroundColor(OrganizationTheme.Colors.green)
                        .lineLimit(1)
                }

                Text(event.title)
                    .font(AppTheme.textStyle(size: 12, weight: .semibold))
                    .foregroundColor(OrganizationTheme.Colors.primaryText)
                    .lineLimit(1)

                if !event.dateText.isEmpty {
                    Text(event.dateText)
                        .font(AppTheme.textStyle(size: 12, weight: .medium))
                        .foregroundColor(OrganizationTheme.Colors.green)
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 0)

            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(OrganizationTheme.Colors.green)
                    .frame(width: 28, height: 28)

                Image(systemName: "calendar")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(AppTheme.Spacing.xSmall)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(OrganizationTheme.Colors.white100)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(OrganizationTheme.Colors.green.opacity(0.5), lineWidth: 1)
                )
        )
    }
}

#Preview {
    HStack(spacing: AppTheme.Spacing.small) {
        EventCardView(event: TeamEvent.getMockEvents(teamId: "t1").upcoming[0])
        EventCardView(event: TeamEvent.getMockEvents(teamId: "t1").upcoming[1])
    }
    .padding()
    .background(OrganizationTheme.Colors.background)
}
