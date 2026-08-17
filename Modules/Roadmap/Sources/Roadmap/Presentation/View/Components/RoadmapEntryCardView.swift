//
//  RoadmapEntryCardView.swift
//
//
//  Created by Claude on 23/07/2026.
//

import SwiftUI
import Common

/// Reused for both events and tasks — same card UI, different content.
struct RoadmapEntryCardView: View {
    let title: String
    let subtitle: String
    let trailingText: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
            Text(title)
                .font(AppTheme.textStyle(size: 14, weight: .medium))
                .foregroundColor(AppTheme.Colors.black100)

            HStack {
                Text(subtitle)
                    .font(AppTheme.textStyle(size: 13, weight: .medium))
                    .foregroundColor(AppTheme.Colors.gray200)

                Spacer(minLength: AppTheme.Spacing.small)

                Text(trailingText)
                    .font(AppTheme.textStyle(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.Colors.gray200)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xSmall)
        .padding(.vertical, AppTheme.Spacing.xSmall)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .fill(AppTheme.Colors.white100)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.gray100, lineWidth: 1)
                )
        )
    }
}

struct RoadmapEmptyStateView: View {
    let message: LocalizedStringKey

    var body: some View {
        Text(message)
            .font(AppTheme.textStyle(size: 14, weight: .medium))
            .foregroundColor(AppTheme.Colors.gray300)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, AppTheme.Spacing.small)
    }
}
