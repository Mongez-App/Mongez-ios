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

    private let getUserTeamsUseCase: GetUserTeamsUseCaseProtocol

    nonisolated public init(getUserTeamsUseCase: GetUserTeamsUseCaseProtocol) {
        self.getUserTeamsUseCase = getUserTeamsUseCase
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
}
