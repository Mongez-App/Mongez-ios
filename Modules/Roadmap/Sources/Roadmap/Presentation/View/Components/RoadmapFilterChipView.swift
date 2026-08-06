//
//  RoadmapFilterChipView.swift
//
//

import SwiftUI
import Common

/// Chip used for both Courses (text-only) and Event Types (icon + text) in the filter sheet.
/// Selected state is a light purple tint with bold purple text, unselected is a bordered
/// white capsule with black text.
struct RoadmapFilterChipView: View {
    let title: String
    var iconName: String? = nil
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppTheme.Spacing.xxxSmall) {
                if let iconName {
                    Image(systemName: iconName)
                        .font(AppTheme.textStyle(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.purple200)
                }

                Text(title)
                    .font(AppTheme.textStyle(size: 15, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? AppTheme.Colors.purple200 : AppTheme.Colors.black100)
            }
            .padding(.horizontal, AppTheme.Spacing.small)
            .padding(.vertical, AppTheme.Spacing.xSmall)
            .background(
                Capsule()
                    .fill(
                        isSelected
                            ? AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.12)
                            : AppTheme.Colors.white100
                    )
                    .overlay(
                        Capsule()
                            .stroke(isSelected ? Color.clear : AppTheme.Colors.gray200, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
