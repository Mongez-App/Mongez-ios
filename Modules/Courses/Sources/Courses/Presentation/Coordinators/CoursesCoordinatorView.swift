import Foundation
import SwiftUI

public struct CoursesCoordinatorView: View {
    @ObservedObject var coordinator: CoursesCoordinator
    @StateObject var viewModel: CoursesViewModel

    private let courseDetailsFactory: (String, String, String) -> AnyView

    public init(
        coordinator: CoursesCoordinator,
        viewModel: CoursesViewModel,
        courseDetailsFactory: @escaping (String, String, String) -> AnyView
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.courseDetailsFactory = courseDetailsFactory
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            CoursesView(viewModel: viewModel)
                .onAppear {
                    viewModel.onCourseSelected = { [weak coordinator] courseId, courseName, courseType in
                        coordinator?.push(.details(courseId: courseId, courseName: courseName, courseType: courseType))
                    }
                }
                .navigationDestination(for: CoursesRoute.self) { route in
                    switch route {
                    case .details(let courseId, let courseName, let courseType):
                        courseDetailsFactory(courseId, courseName, courseType)
                    }
                }
        }
    }
}

