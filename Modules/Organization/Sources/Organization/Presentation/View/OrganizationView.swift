//
//  OrganizationView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

public struct OrganizationView: View {
    @ObservedObject public var viewModel: OrganizationViewModel

    public init(viewModel: OrganizationViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            OrganizationHeaderView(title: "Organizations")

            OrganizationSegmentedControl(selectedTab: $viewModel.selectedTab)
                .padding(.top, AppTheme.Spacing.xSmall)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: AppTheme.Spacing.small) {
                    switch viewModel.selectedTab {
                    case .myTeams:
                        MyTeamsView(viewModel: viewModel)
                    case .discover:
                        DiscoverView(viewModel: viewModel)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.large)
                .padding(.top, AppTheme.Spacing.small)
                .padding(.bottom, 100)
            }
            .background(OrganizationTheme.Colors.background)
        }
        .background(OrganizationTheme.Colors.background.ignoresSafeArea())
        .overlay(
            Group {
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.15).ignoresSafeArea()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: OrganizationTheme.Colors.accent))
                            .scaleEffect(1.5)
                    }
                }
            }
        )
        .overlay(
            Group {
                if viewModel.joinSuccessMessage != nil {
                    ValidationAlertView(
                        title: "Confirmation",
                        message: viewModel.joinSuccessMessage ?? "",
                        onDismiss: { viewModel.dismissJoinSuccess() }
                    )
                    .transition(.opacity)
                }
            }
        )
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
        .task {
            await viewModel.fetchMyCourses()
            await viewModel.fetchOrganizationScreen()
            await viewModel.fetchMyTeams()
            await viewModel.loadTrendingTeams()
        }
        .onChange(of: viewModel.selectedTab) { _ in
            Task {
                await viewModel.fetchOrganizationScreen()
                await viewModel.fetchMyTeams()
                await viewModel.loadTrendingTeams()
            }
        }
    }
}
