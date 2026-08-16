//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 15/08/2026.
//

import SwiftUI
import Common

public struct DiscoverView: View {
    @ObservedObject var viewModel: OrganizationsViewModel
    @State private var selectedTeam: OrgTeam? = nil
    @State private var inviteCode: String = ""
    @State private var showConfirmation: Bool = false
    
    public init(viewModel: OrganizationsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            VStack(spacing: AppTheme.Spacing.medium) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppTheme.Colors.gray300)
                    
                    TextField("Enter Team name here", text: $viewModel.searchQuery)
                        .font(AppTheme.textStyle(size: 14, weight: .regular))
                        .foregroundColor(AppTheme.Colors.black100)
                        .onChange(of: viewModel.searchQuery) { _ in
                            viewModel.searchTeams()
                        }
                }
                .padding(.horizontal, AppTheme.Spacing.small)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                        .background(AppTheme.Colors.white100)
                        .cornerRadius(AppTheme.radius.small)
                )
                .padding(.horizontal, AppTheme.Spacing.large)
                
                if viewModel.searchQuery.isEmpty {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                            if !viewModel.pendingRequests.isEmpty {
                                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                                    Text("Pending Invitations")
                                        .font(AppTheme.textStyle(size: 18, weight: .bold))
                                        .foregroundColor(AppTheme.Colors.black100)
                                    
                                    ForEach(viewModel.pendingRequests, id: \.teamId) { team in
                                        OrgTeamCardView(team: team, isPending: true)
                                    }
                                }
                                .padding(.horizontal, AppTheme.Spacing.large)
                            }
                            
                            if !viewModel.trendingTeams.isEmpty {
                                VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                                    Text("Trending Teams")
                                        .font(AppTheme.textStyle(size: 18, weight: .bold))
                                        .foregroundColor(AppTheme.Colors.black100)
                                    
                                    ForEach(viewModel.trendingTeams, id: \.teamId) { team in
                                        OrgTeamCardView(team: team, isPending: false)
                                            .onTapGesture {
                                                inviteCode = ""
                                                selectedTeam = team
                                            }
                                    }
                                }
                                .padding(.horizontal, AppTheme.Spacing.large)
                            }
                        }
                        .padding(.vertical, AppTheme.Spacing.small)
                        .padding(.bottom, 80) // Add padding to not overlap with bottom nav if present
                    }
                } else {
                    if viewModel.isSearchLoading {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.purple200))
                            .scaleEffect(1.5)
                        Spacer()
                    } else if viewModel.searchResults.isEmpty {
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
                            
                            Text("No Teams Found")
                                .font(AppTheme.textStyle(size: 18, weight: .bold))
                                .foregroundColor(AppTheme.Colors.black100)
                                .padding(.bottom, 8)
                            
                            Text("Unfortunately no teams found with the\nentered name")
                                .font(AppTheme.textStyle(size: 14, weight: .regular))
                                .foregroundColor(AppTheme.Colors.gray300)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: AppTheme.Spacing.small) {
                                ForEach(viewModel.searchResults, id: \.teamId) { team in
                                    OrgTeamCardView(team: team, isPending: false)
                                        .onTapGesture {
                                            inviteCode = ""
                                            selectedTeam = team
                                        }
                                }
                            }
                            .padding(.horizontal, AppTheme.Spacing.large)
                            .padding(.vertical, AppTheme.Spacing.small)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchDiscoverTeams()
            }
            
            // Custom Confirmation Overlay
            if showConfirmation, let response = viewModel.joinResponse {
                Color.black.opacity(0.2).ignoresSafeArea()
                    .onTapGesture {
                        showConfirmation = false
                    }
                
                VStack(spacing: AppTheme.Spacing.medium) {
                    Text("Confirmation")
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                        .padding(.top, AppTheme.Spacing.small)
                    
                    Text(response.message)
                        .font(AppTheme.textStyle(size: 16, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray300)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.Spacing.large)
                    
                    Button(action: {
                        showConfirmation = false
                        viewModel.joinResponse = nil
                    }) {
                        Text("OK")
                            .font(AppTheme.textStyle(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.white100)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(AppTheme.Colors.purple200)
                            .cornerRadius(AppTheme.radius.small)
                    }
                    .padding(.horizontal, AppTheme.Spacing.large)
                    .padding(.bottom, AppTheme.Spacing.large)
                }
                .padding()
                .background(AppTheme.Colors.white100)
                .cornerRadius(AppTheme.radius.large)
                .appShadow(opacity: 0.1, radius: 10, y: 5)
                .padding(.horizontal, 40)
            }
        }
        .sheet(item: Binding<OrgTeam?>(
            get: { selectedTeam },
            set: { selectedTeam = $0 }
        )) { team in
            JoinTeamBottomSheet(team: team, inviteCode: $inviteCode) {
                if !inviteCode.isEmpty {
                    viewModel.joinTeam(inviteCode: inviteCode)
                    selectedTeam = nil
                }
            }
            .presentationDetents([.height(300)])
            .presentationDragIndicator(.hidden)
        }
        .onChange(of: viewModel.joinResponse != nil) { newValue in
            if newValue {
                showConfirmation = true
            }
        }
    }
}

extension OrgTeam: Identifiable {
    public var id: String { teamId }
}

#Preview {
    struct MockGetUserTeamsUseCase: GetUserTeamsUseCaseProtocol {
        func execute() async throws -> [Team] { return [] }
    }
    struct MockDiscoverTeamsUseCase: DiscoverTeamsUseCaseProtocol {
        func execute() async throws -> OrgTeamsResponse {
            let pending = [
                OrgTeam(teamId: "1", name: "Team Name", imageUrl: "", organizationName: "Organization Name", appliedAt: "2024-05-25T10:00:00Z", status: "PENDING")
            ]
            let trending = [
                OrgTeam(teamId: "2", name: "Team Name", imageUrl: "", organizationName: "Organization Name", appliedAt: "", status: "NOT_A_MEMBER")
            ]
            return OrgTeamsResponse(pendingRequests: pending, trendingTeams: trending)
        }
    }
    struct MockJoinTeamUseCase: JoinTeamUseCaseProtocol {
        func execute(inviteCode: String) async throws -> JoinTeamResponse {
            return JoinTeamResponse(message: "Your request has been sent for Organization Name")
        }
    }
    struct MockSearchTeamsUseCase: SearchTeamsUseCaseProtocol {
        func execute(query: String) async throws -> SearchResponse { return SearchResponse(data: []) }
    }
    
    let viewModel = OrganizationsViewModel(
        getUserTeamsUseCase: MockGetUserTeamsUseCase(),
        discoverTeamsUseCase: MockDiscoverTeamsUseCase(),
        joinTeamUseCase: MockJoinTeamUseCase(),
        searchTeamsUseCase: MockSearchTeamsUseCase()
    )
    
    return DiscoverView(viewModel: viewModel)
}
