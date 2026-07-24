//
//  RoadmapSegmentedTabView.swift
//
//
//  Created by Claude on 23/07/2026.
//

import SwiftUI
import Common

/// Generic underline-style segmented control, reusable for any `CaseIterable & Identifiable` tab enum.
struct RoadmapSegmentedTabView<Tab: CaseIterable & Identifiable & RawRepresentable>: View where Tab.RawValue == String, Tab.AllCases: RandomAccessCollection {
    @Binding var selection: Tab

    var body: some View {
        HStack(spacing: AppTheme.Spacing.large) {
            ForEach(Tab.allCases) { tab in
                let isSelected = tab.id == selection.id

                VStack(spacing: AppTheme.Spacing.xxxSmall) {
                    Text(tab.rawValue)
                        .font(AppTheme.textStyle(size: 15, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? AppTheme.Colors.purple200 : AppTheme.Colors.gray300)

                    Rectangle()
                        .fill(isSelected ? AppTheme.Colors.purple200 : Color.clear)
                        .frame(height: 2)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = tab
                    }
                }
            }

            Spacer()
        }
        .overlay(
            Rectangle()
                .fill(AppTheme.Colors.gray100)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}
