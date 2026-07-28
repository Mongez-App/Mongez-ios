//
//  SwiftUIView.swift
//
//
//  Created by Ahmed Tarek on 27/07/2026.
//

import SwiftUI
import Common

struct TodayTasksView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: AppTheme.Spacing.small) {
                Button(action: {
                    dismiss()
                }) {
                    Image("back")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(AppTheme.Colors.purple200)
                        .frame(width: 26, height: 26)
                }
                .padding(.trailing, 2)
                
                Text(viewModel.todayFocus?.courseName ?? "Today's Tasks")
                    .font(AppTheme.textStyle(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .lineLimit(1)
                
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.small)
            .padding(.top, AppTheme.Spacing.xxSmall)
            .padding(.bottom, AppTheme.Spacing.small)
            .frame(maxWidth: .infinity)
            .background(
                AppTheme.Colors.white100
                    .appShadow(opacity: 0.20, radius: 3, y: 1)
                    .ignoresSafeArea(edges: .top)
            )
            
            
            Group {
                if viewModel.todayTasks.isEmpty {
                    VStack(alignment: .center, spacing: AppTheme.Spacing.xLarge) {
                        Image("empty-tasks")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                        
                        Text("No tasks for today!")
                            .font(AppTheme.textStyle(size: 20, weight: .medium))
                            .foregroundColor(AppTheme.Colors.black100)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        TasksList(todayTasks: $viewModel.todayTasks) { selectedTask in
                            viewModel.selectTask(
                                courseId: viewModel.todayFocus?.courseId ?? "",
                                taskTitle: selectedTask.title,
                                isCompleted: selectedTask.isCompleted
                            )
                        }
                        .padding(.horizontal, AppTheme.Spacing.small)
                        .padding(.top, AppTheme.Spacing.small)
                    }
                }
            }
        }
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }
}
