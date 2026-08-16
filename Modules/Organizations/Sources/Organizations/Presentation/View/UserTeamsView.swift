//
//  SwiftUIView.swift
//
//
//  Created by Ahmed Tarek on 15/08/2026.
//

import SwiftUI
import Common

public struct UserTeamsView: View {
    @ObservedObject var viewModel: OrganizationsViewModel
    
    public init(viewModel: OrganizationsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.purple200))
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.teams.isEmpty {
                VStack(spacing: 0) {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(AppTheme.Colors.purple200.opacity(0.25))
                            .frame(width: 130, height: 130)
                        
                        Image("group")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 72, height: 72)
                            .foregroundColor(AppTheme.Colors.purple200)
                    }
                    .padding(.bottom, 8)
                    
                    Text("No Teams Yet")
                        .font(AppTheme.textStyle(size: 18, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                        .padding(.bottom, 8)
                    
                    Text("You haven't joined any teams yet. Search for\na code or browse public campus groups.")
                        .font(AppTheme.textStyle(size: 14, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray300)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                    
                    Spacer()
                        .frame(height: 32)
                    
                    Button(action: {
                        withAnimation {
                            viewModel.selectedTab = .discover
                        }
                    }) {
                        Text("Join Your First Team")
                            .font(AppTheme.textStyle(size: 14, weight: .medium))
                            .foregroundColor(AppTheme.Colors.white100)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(AppTheme.Colors.purple200)
                            .cornerRadius(AppTheme.radius.small)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: AppTheme.Spacing.small) {
                        ForEach(viewModel.teams, id: \.teamId) { team in
                            UserTeamCardView(team: team)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.large)
                    .padding(.vertical, AppTheme.Spacing.small)
                }
            }
        }
        .onAppear {
            viewModel.fetchTeams()
        }
    }
}
