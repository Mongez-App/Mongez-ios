//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import SwiftUI

public struct DashboardCoordinatorView: View {
    @ObservedObject var coordinator: DashboardCoordinator
    @StateObject var viewModel: DashboardViewModel
    
    private let studyRoomFactory: (String, String) -> AnyView
    
    public init(
        coordinator: DashboardCoordinator,
        viewModel: DashboardViewModel,
        studyRoomFactory: @escaping (String, String) -> AnyView
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.studyRoomFactory = studyRoomFactory
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            DashboardView(viewModel: viewModel)
                .onAppear {
                    viewModel.onTaskSelected = { [weak coordinator] courseId, taskTitle in
                        coordinator?.push(.studyRoom(courseId: courseId, taskTitle: taskTitle))
                    }
                }
                .navigationDestination(for: DashboardRoute.self) { route in
                    switch route {
                    case .studyRoom(let courseId, let taskTitle):
                        studyRoomFactory(courseId, taskTitle)
                    }
                }
        }
    }
}
