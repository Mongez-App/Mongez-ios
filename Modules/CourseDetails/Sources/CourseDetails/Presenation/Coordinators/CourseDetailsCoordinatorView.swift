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
    private let onStudyRoomSelected: (String, String) -> Void
    
    public init(
        coordinator: CourseDetailsCoordinator,
        viewModel: CourseDetailsViewModel,
        onStudyRoomSelected: @escaping (String, String) -> Void
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onStudyRoomSelected = onStudyRoomSelected
    }
    
    public var body: some View {
        CourseDetailsView(viewModel: viewModel)
            .onAppear {
                viewModel.onTaskSelected = { courseId, taskTitle in
                    onStudyRoomSelected(courseId, taskTitle)
                }
            }
    }
}
