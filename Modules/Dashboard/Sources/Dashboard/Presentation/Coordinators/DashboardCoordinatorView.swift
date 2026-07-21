//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import SwiftUI
import Common

public struct DashboardCoordinatorView: View {
    @ObservedObject var coordinator: DashboardCoordinator
    @StateObject var viewModel: DashboardViewModel
    
    private let studyRoomFactory: (String, String) -> AnyView
    private let coursesFactory: () -> AnyView
    
    public init(
        coordinator: DashboardCoordinator,
        viewModel: DashboardViewModel,
        studyRoomFactory: @escaping (String, String) -> AnyView,
        coursesFactory: @escaping () -> AnyView
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.studyRoomFactory = studyRoomFactory
        self.coursesFactory = coursesFactory
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            
            MainTabContainer(selectedTab: $coordinator.selectedTab) { tab in
                switch tab {
                case .dashboard:
                    DashboardView(viewModel: viewModel)
                        .onAppear {
                            viewModel.onTaskSelected = { [weak coordinator] courseId, taskTitle in
                                coordinator?.push(.studyRoom(courseId: courseId, taskTitle: taskTitle))
                            }
                        }
                
                case .courses:
                    coursesFactory()
                    
                case .roadmap:
                    Text("Roadmap View")
                    
                case .profile:
                    Text("Profile View")
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
