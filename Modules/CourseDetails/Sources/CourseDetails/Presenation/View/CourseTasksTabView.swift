//
//  File.swift
//
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct CourseTasksTabView: View {
    @ObservedObject var viewModel: CourseDetailsViewModel
    let filters = ["All", "Pending", "Completed", "High", "Medium"]
    @State private var selectedFilter = "All"
    
    public init(viewModel: CourseDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                
                CourseProgressCardView(
                    progressPercentage: viewModel.progressPercentage,
                    completedTasksCount: viewModel.completedTasksCount,
                    totalTasksCount: viewModel.totalTasksCount
                )
                
                TaskFilterScrollView(
                    filters: filters,
                    selectedFilter: selectedFilter,
                    onFilterSelected: { newFilter in
                        selectedFilter = newFilter
                    }
                )
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                    let todayTasks = viewModel.tasks.filter { $0.group == .today }
                    if !todayTasks.isEmpty {
                        Text("Today Tasks")
                            .font(AppTheme.textStyle(size: 16, weight: .bold))
                            .foregroundColor(AppTheme.Colors.black100)
                            .padding(.horizontal, AppTheme.Spacing.small)
                        
                        ForEach(todayTasks) { task in
                            TaskRowView(task: task)
                                .padding(.horizontal, AppTheme.Spacing.small)
                        }
                    }
                    
                    let upcomingTasks = viewModel.tasks.filter { $0.group == .upcoming }
                    if !upcomingTasks.isEmpty {
                        Text("Upcoming Tasks")
                            .font(AppTheme.textStyle(size: 16, weight: .bold))
                            .foregroundColor(AppTheme.Colors.black100)
                            .padding(.horizontal, AppTheme.Spacing.small)
                        
                        ForEach(upcomingTasks) { task in
                            TaskRowView(task: task)
                                .padding(.horizontal, AppTheme.Spacing.small)
                        }
                    }
                }
            }
            .padding(.vertical, AppTheme.Spacing.small)
        }
    }
}
