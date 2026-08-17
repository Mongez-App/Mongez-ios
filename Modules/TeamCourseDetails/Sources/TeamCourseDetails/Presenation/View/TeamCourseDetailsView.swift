//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common
import UniformTypeIdentifiers

public struct TeamCourseDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: TeamCourseDetailsViewModel
    
    public init(viewModel: TeamCourseDetailsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            TeamCourseHeaderView(
                title: viewModel.courseName,
                onBack: { dismiss() }
            )
            
            TeamCourseTabBarView(selectedTab: $viewModel.selectedTab)
            
            if viewModel.selectedTab == 0 {
                TeamCourseMaterialsTabView(
                    materials: viewModel.materials,
                    courseType: viewModel.courseType,
                    isLoading: viewModel.isLoading
                )
            } else {
                TeamCourseTasksTabView(viewModel: viewModel)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .task {
            await viewModel.loadData()
        }
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.15).ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.purple200))
                        .scaleEffect(1.5)
                }
            }
        }
    }
}
