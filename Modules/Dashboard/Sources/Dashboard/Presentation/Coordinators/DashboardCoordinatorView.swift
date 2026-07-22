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
    private let courseDetailsFactory: (String) -> AnyView
    private let coursesFactory: () -> AnyView
    private let profileFactory: () -> AnyView
    
    public init(
        coordinator: DashboardCoordinator,
        viewModel: DashboardViewModel,
        studyRoomFactory: @escaping (String, String) -> AnyView,
        courseDetailsFactory: @escaping (String) -> AnyView,
        coursesFactory: @escaping () -> AnyView,
        profileFactory: @escaping () -> AnyView
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.studyRoomFactory = studyRoomFactory
        self.courseDetailsFactory = courseDetailsFactory
        self.coursesFactory = coursesFactory
        self.profileFactory = profileFactory
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
                    profileFactory()
                }
            }
            .navigationDestination(for: DashboardRoute.self) { route in
                switch route {
                case .studyRoom(let courseId, let taskTitle):
                    studyRoomFactory(courseId, taskTitle)
                case .courseDetails(let courseId):
                    courseDetailsFactory(courseId)
                }
            }
        }
    }
}
