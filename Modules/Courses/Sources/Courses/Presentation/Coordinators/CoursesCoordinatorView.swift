import Foundation
import SwiftUI

public struct CoursesCoordinatorView: View {
    @ObservedObject var coordinator: CoursesCoordinator
    @StateObject var viewModel: CoursesViewModel

    private let courseDetailsFactory: (String) -> AnyView

    public init(
        coordinator: CoursesCoordinator,
        viewModel: CoursesViewModel,
        courseDetailsFactory: @escaping (String) -> AnyView
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.courseDetailsFactory = courseDetailsFactory
    }

    public var body: some View {
        NavigationStack(path: $coordinator.path) {
            CoursesView(viewModel: viewModel)
                .onAppear {
                    viewModel.onCourseSelected = { [weak coordinator] courseId in
                        coordinator?.push(.details(courseId: courseId))
                    }
                }
                .navigationDestination(for: CoursesRoute.self) { route in
                    switch route {
                    case .details(let courseId):
                        courseDetailsFactory(courseId)
                    }
                }
        }
    }
}

