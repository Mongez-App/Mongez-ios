//
//  RoadmapHeaderView.swift
//
//
//  Created by Claude on 23/07/2026.
//

import SwiftUI
import Common

struct RoadmapHeaderView: View {
    var onFilterTapped: () -> Void = {}
    var onAddTapped: () -> Void = {}

    var body: some View {
        HStack {
            Text("Roadmap")
                .font(AppTheme.textStyle(size: 28, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            Spacer()

            HStack(spacing: AppTheme.Spacing.xSmall) {
                headerButton(systemImage: "line.3.horizontal.decrease", action: onFilterTapped)
                headerButton(systemImage: "plus", action: onAddTapped)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.small)
    }

    private func headerButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(AppTheme.textStyle(size: 16, weight: .semibold))
                .foregroundColor(AppTheme.Colors.purple200)
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .foregroundColor(AppTheme.Colors.white100).appShadow(opacity: 0.7, radius: 2)
                )
        }
    }
}
