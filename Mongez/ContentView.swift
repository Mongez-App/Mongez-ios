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
import Organizations
import Payment

struct ContentView: View {
    @StateObject private var appCoordinator = AppCoordinator()
    @AppStorage("user_appearance") private var userAppearance: String = "Light Mode"
    
    var body: some View {
        Group {
            switch appCoordinator.state {
                
            case .splash:
                SplashScreenView(
                    logoImageName: "logo",
                    sloganImageName: "slogan",
                    onSplashFinished: {
                        appCoordinator.finishSplash()
                    }
                )
                .transition(.opacity)
                
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
                        viewModel: DashboardViewModel(
                            getDashboardDetailsUseCase: GetDashboardDetailsUseCase(
                                dashboardRepository: DashboardRepository(
                                    remoteDataSource: DashboardRemoteDataSource()
                                )
                            ),
                            getUserUseCase: GetUserUseCase(
                                dashboardRepository: DashboardRepository(
                                    remoteDataSource: DashboardRemoteDataSource()
                                )
                            )
                        ),
                        studyRoomFactory: { taskId, taskTitle in
                            let studyViewModel = ServiceLocator.resolve(StudyRoomViewModel.self, arguments: taskId, taskTitle)!
                            
                            return AnyView(
                                StudyRoomView(
                                    viewModel: studyViewModel
                                )
                            )
                        },
                        courseDetailsFactory: { courseId, courseName, courseType in
                            let detailsCoordinator = CourseDetailsCoordinator()
                            let detailsViewModel = ServiceLocator.resolve(CourseDetailsViewModel.self, arguments: courseId, courseName, courseType)!
                            
                            return AnyView(
                                CourseDetailsCoordinatorView(
                                    coordinator: detailsCoordinator,
                                    viewModel: detailsViewModel,
                                    onStudyRoomSelected: { taskId, taskTitle in
                                        coordinator.push(.studyRoom(taskId: taskId, taskTitle: taskTitle))
                                    }
                                )
                            )
                        },
                        coursesFactory: {
                            AnyView(
                                DashboardCoursesContainer(
                                    coordinator: coordinator,
                                    viewModel: appCoordinator.makeCoursesViewModel()
                                )
                            )
                        },
                        roadmapFactory: {
                            AnyView(
                                RoadmapView(viewModel: RoadmapViewmodel())
                            )
                        },
                        organizationsFactory: {
                            let organizationsViewModel = ServiceLocator.resolve(OrganizationsViewModel.self)!
                            return AnyView(
                                OrganizationsView(viewModel: organizationsViewModel)
                            )
                        },
                        profileFactory: {
                            AnyView(
                                ProfileView(subscriptionScreenFactory: {
                                    AnyView(PaymentView(viewModel: ServiceLocator.resolve(PaymentViewModel.self)!))
                                })
                            )
                        }
                    )
                    .transition(.opacity)
                }
            case .courses:
                if let coordinator = appCoordinator.coursesCoordinator {
                    let coursesViewModel = appCoordinator.makeCoursesViewModel()
                    CoursesCoordinatorView(
                        coordinator: coordinator,
                        viewModel: coursesViewModel,
                        courseDetailsFactory: { courseId, courseName, courseType in
                            let detailsCoordinator = CourseDetailsCoordinator()
                            let detailsViewModel = ServiceLocator.resolve(CourseDetailsViewModel.self, arguments: courseId, courseName, courseType)!

                            return AnyView(
                                CourseDetailsCoordinatorView(
                                    coordinator: detailsCoordinator,
                                    viewModel: detailsViewModel,
                                    onStudyRoomSelected: { taskId, taskTitle in
                                        coordinator.push(.details(courseId: courseId, courseName: courseName, courseType: courseType))
                                    }
                                )
                            )
                        },
                        upgradeScreenFactory: {
                            AnyView(PaymentView(viewModel: ServiceLocator.resolve(PaymentViewModel.self)!))
                        }
                    )
                    .onAppear {
                        coursesViewModel.isSubscribed = {
                            ServiceLocator.resolve(GetSubscriptionStatusUseCase.self)?.execute() ?? false
                        }
                    }
                    .transition(.opacity)
                }
            }
        }
        .animation(.easeInOut, value: appCoordinator.state)
        .preferredColorScheme(
            userAppearance == "Dark Mode" ? .dark :
            userAppearance == "Light Mode" ? .light :
            nil 
        )
    }
}

struct DashboardCoursesContainer: View {
    let coordinator: DashboardCoordinator
    let viewModel: CoursesViewModel

    var body: some View {
        // The upgrade sheet is presented from inside CoursesView, which observes the view model —
        // attaching it here (a non-observing parent) desyncs SwiftUI's presentation state.
        CoursesView(
            viewModel: viewModel,
            upgradeScreenFactory: {
                AnyView(PaymentView(viewModel: ServiceLocator.resolve(PaymentViewModel.self)!))
            }
        )
        .onAppear {
            viewModel.onCourseSelected = { [weak coordinator] courseId, courseName, courseType in
                coordinator?.push(.courseDetails(courseId: courseId, courseName: courseName, courseType: courseType))
            }
            viewModel.isSubscribed = {
                ServiceLocator.resolve(GetSubscriptionStatusUseCase.self)?.execute() ?? false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
