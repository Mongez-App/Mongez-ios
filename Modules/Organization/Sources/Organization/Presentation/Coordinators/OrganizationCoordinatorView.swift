//
//  OrganizationCoordinatorView.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import SwiftUI
import Common

public struct OrganizationCoordinatorView: View {
    @ObservedObject var coordinator: OrganizationCoordinator
    @StateObject var viewModel: OrganizationViewModel

    public init(
        coordinator: OrganizationCoordinator,
        viewModel: OrganizationViewModel
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            OrganizationView(viewModel: viewModel)
                .onAppear {
                    viewModel.onTeamSelected = { [weak coordinator] teamId in
                        coordinator?.push(.teamDetails(teamId: teamId))
                    }
                }
                .navigationDestination(for: OrganizationRoute.self) { route in
                    switch route {
                    case .teamDetails(let teamId):
                        TeamDetailsView(
                            team: viewModel.teams.first { $0.id == teamId },
                            viewModel: viewModel
                        )
                    }
                }
        }
    }
}
