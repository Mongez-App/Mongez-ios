//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 15/08/2026.
//

import Foundation
import Combine

public enum OrganizationTab: String, CaseIterable {
    case myTeams = "My Teams"
    case discover = "Discover"
}

@MainActor
public final class OrganizationsViewModel: ObservableObject {
    @Published public var selectedTab: OrganizationTab = .myTeams
    @Published public var teams: [Team] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    public var onTeamSelected: ((String, String, String) -> Void)?
    
    // Discover State
    @Published public var searchQuery: String = ""
    @Published public var pendingRequests: [OrgTeam] = []
    @Published public var trendingTeams: [OrgTeam] = []
    @Published public var searchResults: [OrgTeam] = []
    @Published public var isDiscoverLoading: Bool = false
    @Published public var isSearchLoading: Bool = false
    @Published public var isJoiningTeam: Bool = false
    @Published public var joinResponse: JoinTeamResponse? = nil

    private let getUserTeamsUseCase: GetUserTeamsUseCaseProtocol
    private let discoverTeamsUseCase: DiscoverTeamsUseCaseProtocol
    private let joinTeamUseCase: JoinTeamUseCaseProtocol
    private let searchTeamsUseCase: SearchTeamsUseCaseProtocol
    
    private var cancellables = Set<AnyCancellable>()

    nonisolated public init(
        getUserTeamsUseCase: GetUserTeamsUseCaseProtocol,
        discoverTeamsUseCase: DiscoverTeamsUseCaseProtocol,
        joinTeamUseCase: JoinTeamUseCaseProtocol,
        searchTeamsUseCase: SearchTeamsUseCaseProtocol
    ) {
        self.getUserTeamsUseCase = getUserTeamsUseCase
        self.discoverTeamsUseCase = discoverTeamsUseCase
        self.joinTeamUseCase = joinTeamUseCase
        self.searchTeamsUseCase = searchTeamsUseCase
    }

    public func fetchTeams() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                teams = try await getUserTeamsUseCase.execute()
            } catch {
                errorMessage = error.localizedDescription
                print("Failed to fetch teams: \(error)")
            }
            isLoading = false
        }
    }
    
    public func selectTeam(team: Team) {
        onTeamSelected?(team.teamId, team.name, team.organizationName)
    }
    
    public func fetchDiscoverTeams() {
        Task {
            isDiscoverLoading = true
            errorMessage = nil
            do {
                let response = try await discoverTeamsUseCase.execute()
                pendingRequests = response.pendingRequests
                trendingTeams = response.trendingTeams
            } catch {
                errorMessage = error.localizedDescription
                print("Failed to fetch discover teams: \(error)")
            }
            isDiscoverLoading = false
        }
    }
    
    public func searchTeams() {
        guard !searchQuery.isEmpty else {
            searchResults = []
            return
        }
        
        Task {
            isSearchLoading = true
            errorMessage = nil
            do {
                let response = try await searchTeamsUseCase.execute(query: searchQuery)
                searchResults = response.data
            } catch {
                errorMessage = error.localizedDescription
                print("Failed to search teams: \(error)")
            }
            isSearchLoading = false
        }
    }
    
    public func joinTeam(inviteCode: String) {
        Task {
            isJoiningTeam = true
            errorMessage = nil
            do {
                let response = try await joinTeamUseCase.execute(inviteCode: inviteCode)
                joinResponse = response
                // Refresh discover teams after joining
                fetchDiscoverTeams()
            } catch {
                errorMessage = error.localizedDescription
                print("Failed to join team: \(error)")
            }
            isJoiningTeam = false
        }
    }
}
