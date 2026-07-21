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
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CourseDetailsViewModel
    @State private var showEditSheet: Bool = false
    
    public init(viewModel: CourseDetailsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CourseHeaderView(
                title: "Opearating Systems",
                onBack: { dismiss() },
                onEdit: { showEditSheet = true },
                onDelete: {  }
            )
            .sheet(isPresented: $showEditSheet) {
                EditCourseSheetView()
                    .presentationDetents([.fraction(0.85)])
            }
            
            CourseTabBarView(selectedTab: $viewModel.selectedTab)
            
            if viewModel.selectedTab == 0 {
                CourseMaterialsTabView(materials: viewModel.materials)
            } else {
                CourseTasksTabView(viewModel: viewModel)
            }
        }
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .task {
            await viewModel.loadData()
        }
    }
}
