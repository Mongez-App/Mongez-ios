//
//  File.swift
//  
//
//  Created by Mazen Amr on 21/07/2026.
//

import Foundation
import SwiftUI

public struct CourseDetailsCoordinatorView: View {
    @ObservedObject var coordinator: CourseDetailsCoordinator
    @StateObject var viewModel: CourseDetailsViewModel
    @Binding var path: NavigationPath
    
    private let studyRoomFactory: (String, String) -> AnyView
    
    public init(
        coordinator: CourseDetailsCoordinator,
        viewModel: CourseDetailsViewModel,
        path: Binding<NavigationPath>,
        studyRoomFactory: @escaping (String, String) -> AnyView
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._path = path
        self.studyRoomFactory = studyRoomFactory
    }
    
    public var body: some View {
        CourseDetailsView(viewModel: viewModel)
            .onAppear {
                viewModel.onTaskSelected = { courseId, taskTitle in
                    path.append(CourseDetailsRoute.studyRoom(courseId: courseId, taskTitle: taskTitle))
                }
            }
            .navigationDestination(for: CourseDetailsRoute.self) { route in
                switch route {
                case .studyRoom(let courseId, let taskTitle):
                    studyRoomFactory(courseId, taskTitle)
                }
            }
    }
}
