//
//  File.swift
//  
//
//  Created by Mazen Amr on 21/07/2026.
//

import Foundation
import SwiftUI

public struct TeamCourseDetailsCoordinatorView: View {
    @ObservedObject var coordinator: TeamCourseDetailsCoordinator
    @StateObject var viewModel: TeamCourseDetailsViewModel
    private let onStudyRoomSelected: (String, String) -> Void
    
    public init(
        coordinator: TeamCourseDetailsCoordinator,
        viewModel: TeamCourseDetailsViewModel,
        onStudyRoomSelected: @escaping (String, String) -> Void
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onStudyRoomSelected = onStudyRoomSelected
    }
    
    public var body: some View {
        TeamCourseDetailsView(viewModel: viewModel)
            .onAppear {
                viewModel.onTaskSelected = { taskId, taskTitle in
                    onStudyRoomSelected(taskId, taskTitle)
                }
            }
    }
}
