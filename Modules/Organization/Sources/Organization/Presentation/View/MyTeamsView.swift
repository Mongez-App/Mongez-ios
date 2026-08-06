//
//  MyTeamsView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

struct MyTeamsView: View {
    @ObservedObject var viewModel: OrganizationViewModel

    var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            if viewModel.teams.isEmpty {
                EmptyStateView(
                    icon: "building.2",
                    title: "No Teams Yet",
                    message: "You haven't joined any teams yet. Search for a code or browse public campus groups.",
                    actionTitle: "Join Your First Team",
                    onAction: {
                        viewModel.selectedTab = .discover
                    }
                )
            } else {
                teamsSection
            }
        }
    }

    private var teamsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("My Teams")
                .font(AppTheme.textStyle(size: 18, weight: .semibold))
                .foregroundColor(OrganizationTheme.Colors.primaryText)

            VStack(spacing: AppTheme.Spacing.small) {
                ForEach(viewModel.teams) { team in
                    TeamCardView(team: team) {
                        viewModel.selectTeam(id: team.id)
                    }
                }
            }
        }
    }
}
