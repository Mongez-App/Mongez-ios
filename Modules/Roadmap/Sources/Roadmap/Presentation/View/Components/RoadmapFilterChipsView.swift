//
//  RoadmapFilterChipsView.swift
//
//
//  Created by Claude on 23/07/2026.
//

import SwiftUI
import Common

/// Horizontally scrollable capsule chips — works for both single-select (status)
/// and multi-select (courses) by leaving the selection logic to the caller.
struct RoadmapFilterChipsView: View {
    let options: [String]
    let isSelected: (String) -> Bool
    let onTap: (String) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.small) {
                ForEach(options, id: \.self) { option in
                    let selected = isSelected(option)

                    Text(option)
                        .font(AppTheme.textStyle(size: 14, weight: selected ? .bold : .medium))
                        .foregroundColor(selected ? AppTheme.Colors.white100 : AppTheme.Colors.gray300)
                        .padding(.horizontal, AppTheme.Spacing.small)
                        .padding(.vertical, AppTheme.Spacing.xxSmall)
                        .background(
                            Capsule()
                                .fill(selected ? AppTheme.Colors.purple200 : AppTheme.Colors.white100)
                                .overlay(
                                    Capsule()
                                        .stroke(selected ? Color.clear : AppTheme.Colors.gray200, lineWidth: 1)
                                )
                        )
                        .contentShape(Capsule())
                        .onTapGesture {
                            onTap(option)
                        }
                }
            }
            .padding(.vertical, AppTheme.Spacing.xxxSmall)
        }
    }
}
