//
//  OrganizationViewModel.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation
import SwiftUI

public enum OrganizationTab: String, CaseIterable {
    case myTeams = "My Teams"
    case discover = "Discover"
}

public class OrganizationViewModel: ObservableObject {
    @Published public var selectedTab: OrganizationTab = .myTeams
    @Published public var teams: [Team] = []
    @Published public var myCourses: [TeamCourse] = []
    @Published public var organizationScreen: OrganizationScreen?
    @Published public var pendingRequests: [PendingRequest] = []
    @Published public var searchResults: [Team] = []
    @Published public var trendingTeams: [Team] = []
    @Published public var teamCourses: [TeamCourse] = []
    @Published public var teamEvents: TeamEventsResult = TeamEventsResult(upcoming: [], past: [])
    @Published public var inviteCode: String = ""
    @Published public var searchQuery: String = ""
    @Published public var selectedDiscoverTeam: Team?
    @Published public var isRequestSheetPresented: Bool = false
    @Published public var isSearching: Bool = false
    @Published public var isLoading: Bool = false
    @Published public var isSubmittingJoin: Bool = false
    @Published public var errorMessage: String?
    @Published public var joinSuccessMessage: String?

    public var onTeamSelected: ((String) -> Void)?

    let getMyTeamsUseCase: GetMyTeamsUseCaseProtocol
    let getMyCoursesUseCase: GetMyCoursesUseCaseProtocol
    let getOrganizationScreenUseCase: GetOrganizationScreenUseCaseProtocol
    let searchTeamsUseCase: SearchTeamsUseCaseProtocol
    let joinTeamUseCase: JoinTeamUseCaseProtocol
    let getTeamCoursesUseCase: GetTeamCoursesUseCaseProtocol
    let getTeamEventsUseCase: GetTeamEventsUseCaseProtocol

    public init(
        getMyTeamsUseCase: GetMyTeamsUseCaseProtocol,
        getMyCoursesUseCase: GetMyCoursesUseCaseProtocol,
        getOrganizationScreenUseCase: GetOrganizationScreenUseCaseProtocol,
        searchTeamsUseCase: SearchTeamsUseCaseProtocol,
        joinTeamUseCase: JoinTeamUseCaseProtocol,
        getTeamCoursesUseCase: GetTeamCoursesUseCaseProtocol,
        getTeamEventsUseCase: GetTeamEventsUseCaseProtocol
    ) {
        self.getMyTeamsUseCase = getMyTeamsUseCase
        self.getMyCoursesUseCase = getMyCoursesUseCase
        self.getOrganizationScreenUseCase = getOrganizationScreenUseCase
        self.searchTeamsUseCase = searchTeamsUseCase
        self.joinTeamUseCase = joinTeamUseCase
        self.getTeamCoursesUseCase = getTeamCoursesUseCase
        self.getTeamEventsUseCase = getTeamEventsUseCase
    }

    public func selectTeam(id: String) {
        onTeamSelected?(id)
    }

    public var canSubmitInvite: Bool {
        !inviteCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public func selectDiscoverTeam(_ team: Team) {
        selectedDiscoverTeam = team
        inviteCode = team.inviteCode ?? ""
        isRequestSheetPresented = true
    }

    public func dismissRequestSheet() {
        isRequestSheetPresented = false
        selectedDiscoverTeam = nil
        inviteCode = ""
    }

    @MainActor
    public func fetchMyTeams() async {
        isLoading = true
        do {
            teams = try await getMyTeamsUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    public func fetchMyCourses() async {
        do {
            myCourses = try await getMyCoursesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    public func fetchOrganizationScreen() async {
        isLoading = true
        do {
            let screen = try await getOrganizationScreenUseCase.execute()
            organizationScreen = screen
            let approvedIds = Set(screen.approvedTeams.map(\.id))
            pendingRequests = screen.pendingInvites.filter { !approvedIds.contains($0.id) }
            teams = screen.approvedTeams
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    public func searchTeams() async {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        isSearching = true
        errorMessage = nil
        do {
            searchResults = try await searchTeamsUseCase.execute(query: query)
        } catch {
            errorMessage = error.localizedDescription
        }
        isSearching = false
    }

    @MainActor
    public func loadTrendingTeams() async {
        do {
            let results = try await searchTeamsUseCase.execute(query: "")
            if searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                trendingTeams = results
            }
        } catch {
            // Trending is best-effort; keep whatever is already loaded.
        }
    }

    @MainActor
    public func joinTeam() async {
        let code = inviteCode.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !code.isEmpty else { return }

        let teamName = selectedDiscoverTeam?.name
        isSubmittingJoin = true
        errorMessage = nil
        joinSuccessMessage = nil

        do {
            try await joinTeamUseCase.execute(code: code)
            dismissRequestSheet()
            joinSuccessMessage = "Your request has been sent for \(teamName ?? "the team")"
            await fetchOrganizationScreen()
            await fetchMyTeams()
            await searchTeams()
        } catch {
            errorMessage = error.localizedDescription
        }

        isSubmittingJoin = false
    }

    @MainActor
    public func loadTeamDetails(teamId: String) async {
        isLoading = true
        do {
            async let courses = getTeamCoursesUseCase.execute(teamId: teamId)
            async let events = getTeamEventsUseCase.execute(teamId: teamId)
            teamCourses = try await courses
            teamEvents = try await events
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    public func dismissJoinSuccess() {
        joinSuccessMessage = nil
    }
}
