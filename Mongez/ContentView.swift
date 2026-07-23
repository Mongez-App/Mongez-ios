//
//  ContentView.swift
//  Mongez
//
//  Created by mohamed sharaf on 15/07/2026.
//
import Common
import SwiftUI
import CoreData
import OnBoarding
import Authntication
import Dashboard
import AIStudyRoom
import Preferences
import Courses
import CourseDetails
import Profile
import Roadmap

struct ContentView: View {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some View {
        Group {
            switch appCoordinator.state {
                
            case .onboarding:
                if let coordinator = appCoordinator.onboardingCoordinator {
                    OnboardingCoordinatorView(
                        coordinator: coordinator,
                        viewModel: OnboardingViewModel()
                    )
                    .transition(.opacity)
                }
                
            case .auth:
                if let coordinator = appCoordinator.authCoordinator {
                    AuthCoordinatorView(
                        coordinator: coordinator,
                        viewModel: AuthViewModel()
                    )
                    .transition(.opacity)
                }
                
            case .preferences:
                if let coordinator = appCoordinator.preferencesCoordinator {
                    PreferencesCoordinatorView(
                        coordinator: coordinator,
                        viewModel: PreferencesViewModel()
                    )
                    .transition(.opacity)
                }

            case .dashboard:
                if let coordinator = appCoordinator.dashboardCoordinator {
                    DashboardCoordinatorView(
                        coordinator: coordinator,
                        viewModel: DashboardViewModel(),
                        studyRoomFactory: { courseId, taskTitle in
                            let chatRepository = MockChatRepository()
                            let studyViewModel = StudyRoomViewModel(
                                courseId: courseId,
                                getChatHistoryUseCase: GetChatHistoryUseCase(repository: chatRepository),
                                sendMessageUseCase: SendMessageUseCase(repository: chatRepository)
                            )
                            
                            return AnyView(
                                StudyRoomView(
                                    viewModel: studyViewModel,
                                    taskTitle: taskTitle
                                )
                            )
                        },
                        courseDetailsFactory: { courseId in
                            let courseDetailsRepository = MockCourseDetailsRepository()
                            let detailsCoordinator = CourseDetailsCoordinator()
                            let detailsViewModel = CourseDetailsViewModel(
                                courseId: courseId,
                                getMaterialsUseCase: GetCourseMaterialsUseCase(repository: courseDetailsRepository),
                                getTasksUseCase: GetCourseTasksUseCase(repository: courseDetailsRepository)
                            )
                            
                            return AnyView(
                                CourseDetailsCoordinatorView(
                                    coordinator: detailsCoordinator,
                                    viewModel: detailsViewModel,
                                    onStudyRoomSelected: { roomId, taskTitle in
                                        coordinator.push(.studyRoom(courseId: roomId, taskTitle: taskTitle))
                                    }
                                )
                            )
                        },
                        coursesFactory: {
                            AnyView(
                                DashboardCoursesContainer(coordinator: coordinator)
                            )
                        },
                        roadmapFactory: {
                            AnyView(
                                RoadmapView(viewModel: RoadmapViewmodel())
                            )
                        },
                        profileFactory: {
                            AnyView(
                                ProfileView()
                            )
                        }
                    )
                    .transition(.opacity)
                }
            case .courses:
                if let coordinator = appCoordinator.coursesCoordinator {
                    CoursesCoordinatorView(
                        coordinator: coordinator,
                        viewModel: CoursesViewModel(),
                        courseDetailsFactory: { courseId in
                            
                            let courseDetailsRepository = MockCourseDetailsRepository()
                            let detailsCoordinator = CourseDetailsCoordinator()
                            let detailsViewModel = CourseDetailsViewModel(
                                courseId: courseId,
                                getMaterialsUseCase: GetCourseMaterialsUseCase(repository: courseDetailsRepository),
                                getTasksUseCase: GetCourseTasksUseCase(repository: courseDetailsRepository)
                            )
                            
                            return AnyView(
                                CourseDetailsCoordinatorView(
                                    coordinator: detailsCoordinator,
                                    viewModel: detailsViewModel,
                                    onStudyRoomSelected: { roomId, taskTitle in
                                        coordinator.push(.details(courseId: roomId))
                                    }
                                )
                            )
                        }
                    )
                    .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut, value: appCoordinator.state)
    }
}

struct DashboardCoursesContainer: View {
    let coordinator: DashboardCoordinator
    @StateObject private var viewModel = CoursesViewModel()
    
    var body: some View {
        CoursesView(viewModel: viewModel)
            .onAppear {
                viewModel.onCourseSelected = { [weak coordinator] courseId in
                    coordinator?.push(.courseDetails(courseId: courseId))
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
