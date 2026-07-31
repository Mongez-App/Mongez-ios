import Foundation
import SwiftUI

public struct CoursesCoordinatorView: View {
    @ObservedObject var coordinator: CoursesCoordinator
    @StateObject var viewModel: CoursesViewModel

    private let courseDetailsFactory: (String, String) -> AnyView

    public init(
        coordinator: CoursesCoordinator,
        viewModel: CoursesViewModel,
        courseDetailsFactory: @escaping (String, String) -> AnyView
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.courseDetailsFactory = courseDetailsFactory
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            CoursesView(viewModel: viewModel)
                .onAppear {
                    viewModel.onCourseSelected = { [weak coordinator] courseId, courseName in
                        coordinator?.push(.details(courseId: courseId, courseName: courseName))
                    }
                }
                .navigationDestination(for: CoursesRoute.self) { route in
                    switch route {
                    case .details(let courseId, let courseName):
                        courseDetailsFactory(courseId, courseName)
                    }
                }
        }
    }
}

