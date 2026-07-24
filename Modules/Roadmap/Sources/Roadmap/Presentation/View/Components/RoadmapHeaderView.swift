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
                headerButton(icon: "filter", size: 18, action: onFilterTapped)
                headerButton(icon: "add", size: 30, action: onAddTapped)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.small)
    }

    private func headerButton(icon: String, size: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .foregroundColor(AppTheme.Colors.purple200.opacity(0.9))
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .foregroundColor(AppTheme.Colors.white100).appShadow(opacity: 0.7, radius: 2)
                )
        }
    }
}
