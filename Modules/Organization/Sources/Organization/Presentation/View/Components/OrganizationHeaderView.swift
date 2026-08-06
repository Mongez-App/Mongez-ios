//
//  OrganizationHeaderView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

struct OrganizationHeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(AppTheme.textStyle(size: 24, weight: .semibold))
                .foregroundColor(OrganizationTheme.Colors.primaryText)

            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.top, AppTheme.Spacing.small)
        .padding(.bottom, AppTheme.Spacing.small)
        .background(OrganizationTheme.Colors.background.ignoresSafeArea(edges: .top))
    }
}

#Preview {
    OrganizationHeaderView(title: "Organizations")
        .background(OrganizationTheme.Colors.background)
}
