//
//  DiscoverView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

struct DiscoverView: View {
    @ObservedObject var viewModel: OrganizationViewModel

    private var isSearching: Bool {
        !viewModel.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
            SearchInviteField(
                text: $viewModel.searchQuery,
                onSubmit: {
                    Task { await viewModel.searchTeams() }
                }
            )
            .onChange(of: viewModel.searchQuery) { newValue in
                if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    viewModel.searchResults = []
                }
            }
            .padding(.bottom, AppTheme.Spacing.xSmall)

            if !viewModel.pendingRequests.isEmpty {
                pendingSection
            }

            if viewModel.isSearching {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: OrganizationTheme.Colors.accent))
                    Spacer()
                }
                .padding(.vertical, AppTheme.Spacing.large)
            } else {
                if isSearching {
                    searchResultsSection
                } else if !viewModel.trendingTeams.isEmpty {
                    trendingSection
                }
            }
        }
        .overlay(alignment: .bottom) {
            if viewModel.isRequestSheetPresented {
                requestSheet
            }
        }
    }

    private var pendingSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Pending Invitations")
                .font(AppTheme.textStyle(size: 18, weight: .semibold))
                .foregroundColor(OrganizationTheme.Colors.primaryText)

            VStack(spacing: AppTheme.Spacing.small) {
                ForEach(viewModel.pendingRequests) { request in
                    DiscoverCardView(
                        teamName: request.teamName,
                        subtitle: request.organizationName.isEmpty ? "Academic Organization" : request.organizationName,
                        footer: request.appliedDateText
                    ) {}
                }
            }
        }
    }

    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Trending Teams")
                .font(AppTheme.textStyle(size: 18, weight: .semibold))
                .foregroundColor(OrganizationTheme.Colors.primaryText)

            VStack(spacing: AppTheme.Spacing.small) {
                ForEach(viewModel.trendingTeams) { team in
                    DiscoverCardView(
                        teamName: team.name,
                        subtitle: team.type,
                        logoColorHex: team.logoColorHex
                    ) {
                        viewModel.selectDiscoverTeam(team)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var searchResultsSection: some View {
        if viewModel.searchResults.isEmpty {
            EmptyStateView(
                icon: "magnifyingglass",
                title: "No Teams Found",
                message: "Unfortunately no teams found with the entered name"
            )
        } else {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("Search Results")
                    .font(AppTheme.textStyle(size: 18, weight: .semibold))
                    .foregroundColor(OrganizationTheme.Colors.primaryText)

                VStack(spacing: AppTheme.Spacing.small) {
                    ForEach(viewModel.searchResults) { team in
                        DiscoverCardView(
                            teamName: team.name,
                            subtitle: team.type,
                            logoColorHex: team.logoColorHex
                        ) {
                            viewModel.selectDiscoverTeam(team)
                        }
                    }
                }
            }
        }
    }

    private var requestSheet: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture {
                    viewModel.dismissRequestSheet()
                }

            if let team = viewModel.selectedDiscoverTeam {
                RequestSheetView(
                    teamName: team.name,
                    organizationName: team.type,
                    logoColorHex: team.logoColorHex,
                    inviteCode: $viewModel.inviteCode,
                    canSubmit: viewModel.canSubmitInvite,
                    isSubmitting: viewModel.isSubmittingJoin,
                    onSubmit: {
                        Task { await viewModel.joinTeam() }
                    },
                    onDismiss: {
                        viewModel.dismissRequestSheet()
                    }
                )
                .transition(.move(edge: .bottom))
            }
        }
    }
}
