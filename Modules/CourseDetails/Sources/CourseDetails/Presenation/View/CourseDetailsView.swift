//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct CourseDetailsView: View {
    @StateObject var viewModel: CourseDetailsViewModel
    
    public init(viewModel: CourseDetailsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CourseHeaderView(title: "Operating Systems")
            
            CourseTabBarView(selectedTab: $viewModel.selectedTab)
            
            if viewModel.selectedTab == 0 {
                CourseMaterialsTabView(materials: viewModel.materials)
            } else {
                CourseTasksTabView(viewModel: viewModel)
            }
        }
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .task {
            await viewModel.loadData()
        }
    }
}
