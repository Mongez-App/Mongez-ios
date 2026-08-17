import Foundation
import SwiftUI

public struct CoursesCoordinatorView: View {
    @ObservedObject var coordinator: CoursesCoordinator
    @StateObject var viewModel: CoursesViewModel

    private let courseDetailsFactory: (String, String, String) -> AnyView
    private let teamCourseDetailsFactory: (String, String, String, String) -> AnyView
    private let upgradeScreenFactory: () -> AnyView

    public init(
        coordinator: CoursesCoordinator,
        viewModel: CoursesViewModel,
        courseDetailsFactory: @escaping (String, String, String) -> AnyView,
        teamCourseDetailsFactory: @escaping (String, String, String, String) -> AnyView,
        upgradeScreenFactory: @escaping () -> AnyView = { AnyView(EmptyView()) }
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.courseDetailsFactory = courseDetailsFactory
        self.teamCourseDetailsFactory = teamCourseDetailsFactory
        self.upgradeScreenFactory = upgradeScreenFactory
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            CoursesView(viewModel: viewModel, upgradeScreenFactory: upgradeScreenFactory)
                .onAppear {
                    viewModel.onCourseSelected = { [weak coordinator] courseId, courseName, courseType, organizationId in
                        if courseType == "TEAM_COURSE" {
                            coordinator?.push(.teamDetails(courseId: courseId, organizationId: organizationId ?? "", courseName: courseName, courseType: courseType))
                        } else {
                            coordinator?.push(.details(courseId: courseId, courseName: courseName, courseType: courseType))
                        }
                    }
                }
                .navigationDestination(for: CoursesRoute.self) { route in
                    switch route {
                    case .details(let courseId, let courseName, let courseType):
                        courseDetailsFactory(courseId, courseName, courseType)
                    case .teamDetails(let courseId, let organizationId, let courseName, let courseType):
                        teamCourseDetailsFactory(courseId, organizationId, courseName, courseType)
                    }
                }
        }
    }
}

