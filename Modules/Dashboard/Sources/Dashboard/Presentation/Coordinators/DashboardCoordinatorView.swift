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
    private let courseDetailsFactory: (String, String, String) -> AnyView
    private let coursesFactory: () -> AnyView
    private let roadmapFactory: () -> AnyView
    private let organizationsFactory: () -> AnyView
    private let profileFactory: () -> AnyView
    private let teamCoursesFactory: (String, String, String) -> AnyView
    private let teamCourseDetailsFactory: (String, String, String, String) -> AnyView

    public init(
        coordinator: DashboardCoordinator,
        viewModel: DashboardViewModel,
        studyRoomFactory: @escaping (String, String) -> AnyView,
        courseDetailsFactory: @escaping (String, String, String) -> AnyView,
        coursesFactory: @escaping () -> AnyView,
        roadmapFactory: @escaping () -> AnyView,
        organizationsFactory: @escaping () -> AnyView,
        profileFactory: @escaping () -> AnyView,
        teamCoursesFactory: @escaping (String, String, String) -> AnyView,
        teamCourseDetailsFactory: @escaping (String, String, String, String) -> AnyView
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.studyRoomFactory = studyRoomFactory
        self.courseDetailsFactory = courseDetailsFactory
        self.coursesFactory = coursesFactory
        self.roadmapFactory = roadmapFactory
        self.organizationsFactory = organizationsFactory
        self.profileFactory = profileFactory
        self.teamCoursesFactory = teamCoursesFactory
        self.teamCourseDetailsFactory = teamCourseDetailsFactory
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            
            MainTabContainer(selectedTab: $coordinator.selectedTab) { tab in
                switch tab {
                case .dashboard:
                    DashboardView(viewModel: viewModel)
                        .onAppear {
                            viewModel.onTaskSelected = { [weak coordinator] taskId, taskTitle in
                                coordinator?.push(.studyRoom(taskId: taskId, taskTitle: taskTitle))
                            }
                            viewModel.onViewAllTodayTasks = { [weak coordinator] in
                                coordinator?.push(.todayTasks)
                            }
                            viewModel.onViewAllUpcomingDeadlines = { [weak coordinator] in
                                coordinator?.selectedTab = .roadmap
                            }
                            viewModel.onNavigateToProfile = { [weak coordinator] in
                                coordinator?.selectedTab = .profile
                            }
                        }
                
                case .courses:
                    coursesFactory()
                    
                case .roadmap:
                    roadmapFactory()
                    
                case .organizations:
                    organizationsFactory()
                    
                case .profile:
                    profileFactory()
                }
            }
            .navigationDestination(for: DashboardRoute.self) { route in
                switch route {
                case .studyRoom(let taskId, let taskTitle):
                    studyRoomFactory(taskId, taskTitle)
                case .courseDetails(let courseId, let courseName, let courseType):
                    courseDetailsFactory(courseId, courseName, courseType)
                case .todayTasks:
                    TodayTasksView(viewModel: viewModel)
                case .teamCourses(let teamId, let teamName, let orgId):
                    teamCoursesFactory(teamId, teamName, orgId)
                case .teamCourseDetails(let courseId, let organizationId, let courseName, let courseType):
                    teamCourseDetailsFactory(courseId, organizationId, courseName, courseType)
                }
            }
        }
    }
}
