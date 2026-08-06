//
//  OrganizationSegmentedControl.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

struct OrganizationSegmentedControl: View {
    @Binding var selectedTab: OrganizationTab

    var body: some View {
        HStack(spacing: AppTheme.Spacing.xxxSmall) {
            ForEach(OrganizationTab.allCases, id: \.self) { tab in
                let isSelected = selectedTab == tab

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }) {
                    Text(tab.rawValue)
                        .font(AppTheme.textStyle(
                            size: 14,
                            weight: isSelected ? .semibold : .medium
                        ))
                        .foregroundColor(
                            isSelected
                                ? OrganizationTheme.Colors.primaryText
                                : OrganizationTheme.Colors.secondaryText
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                .fill(
                                    isSelected
                                        ? OrganizationTheme.Colors.white100
                                        : Color.clear
                                )
                                .appShadow(
                                    opacity: isSelected ? 0.08 : 0,
                                    radius: 4,
                                    y: 1
                                )
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(AppTheme.Spacing.xxxSmall)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .fill(OrganizationTheme.Colors.border)
        )
        .padding(.horizontal, AppTheme.Spacing.large)
    }
}

#Preview {
    OrganizationSegmentedControl(selectedTab: .constant(.myTeams))
}
