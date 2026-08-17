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
    let filters = ["All", "Pending", "Completed", "High", "Medium", "Low"]
    @State private var selectedFilter = "All"
    
    public init(viewModel: CourseDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    private var filteredTasks: [CourseTask] {
        switch selectedFilter {
        case "Pending":
            return viewModel.tasks.filter { !$0.isCompleted }
        case "Completed":
            return viewModel.tasks.filter { $0.isCompleted }
        case "High":
            return viewModel.tasks.filter { $0.priority == .high }
        case "Medium":
            return viewModel.tasks.filter { $0.priority == .medium }
        case "Low":
            return viewModel.tasks.filter { $0.priority == .low }
        default:
            return viewModel.tasks
        }
    }
    
    private var emptyStateText: LocalizedStringKey {
        switch selectedFilter {
        case "All": return "No tasks found in this course."
        case "Pending": return "No pending tasks found."
        case "Completed": return "No completed tasks."
        case "High": return "No high priority tasks."
        case "Medium": return "No medium priority tasks."
        case "Low": return "No low priority tasks."
        default: return "No tasks found."
        }
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
                
                if filteredTasks.isEmpty {
                    if !viewModel.isLoading {
                        VStack(spacing: AppTheme.Spacing.small) {
                            Spacer()
                            
                            Image("empty-tasks")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(.bottom, AppTheme.Spacing.small)
                            
                            Text(emptyStateText)
                                .font(AppTheme.textStyle(size: 16, weight: .medium))
                                .foregroundColor(AppTheme.Colors.gray300)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 250, alignment: .center)
                    }
                } else {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                        let todayTasks = filteredTasks.filter { $0.group == .today }
                        if !todayTasks.isEmpty {
                            Text("Today Tasks")
                                .font(AppTheme.textStyle(size: 16, weight: .bold))
                                .foregroundColor(AppTheme.Colors.black100)
                                .padding(.horizontal, AppTheme.Spacing.small)
                            
                            ForEach(todayTasks) { task in
                                Button {
                                    viewModel.selectTask(task)
                                } label: {
                                    TaskRowView(task: task)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(task.isCompleted)
                                .padding(.horizontal, AppTheme.Spacing.small)
                            }
                        }
                        
                        let upcomingTasks = filteredTasks.filter { $0.group == .upcoming }
                        if !upcomingTasks.isEmpty {
                            Text("Upcoming Tasks")
                                .font(AppTheme.textStyle(size: 16, weight: .bold))
                                .foregroundColor(AppTheme.Colors.black100)
                                .padding(.horizontal, AppTheme.Spacing.small)
                            
                            ForEach(upcomingTasks) { task in
                                Button {
                                    viewModel.selectTask(task)
                                } label: {
                                    TaskRowView(task: task)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .disabled(task.isCompleted)
                                .padding(.horizontal, AppTheme.Spacing.small)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, AppTheme.Spacing.small)
        }
        .refreshable {
            await viewModel.loadData()
        }
    }
}
