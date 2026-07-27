//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 20/07/2026.
//

import SwiftUI
import Common

struct DashboardView: View {
    @ObservedObject public var viewModel: DashboardViewModel
    
    public init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.user != nil {
                HeaderView(user: $viewModel.user)
                    .zIndex(1)
            }
            
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: AppTheme.Spacing.xLarge) {
                        if let todayFocus = viewModel.todayFocus, todayFocus.courseName != nil {
                            TodayFocusCard(todayFocus: $viewModel.todayFocus)
                                .padding(.horizontal, AppTheme.Spacing.small)
                        }
                        
                        ProgressList(progressMetrics: $viewModel.progressMetrics)
                            .padding(.leading, AppTheme.Spacing.small)
                        
                        VStack(spacing: AppTheme.Spacing.medium) {
                            HStack {
                                Text("Today's Tasks")
                                    .font(AppTheme.textStyle(size: 18, weight: .semibold))
                                    .foregroundColor(AppTheme.Colors.black100)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.onViewAllTodayTasks?()
                                }) {
                                    Text("View all")
                                        .font(AppTheme.textStyle(size: 12, weight: .semibold))
                                        .foregroundColor(AppTheme.Colors.purple200)
                                }
                            }
                            
                            if viewModel.todayTasks.isEmpty {
                                VStack(spacing: AppTheme.Spacing.medium) {
                                    Image("empty-tasks")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 94, height: 94)
                                    
                                    Text("No tasks for today!")
                                        .font(AppTheme.textStyle(size: 16, weight: .medium))
                                        .foregroundColor(AppTheme.Colors.black100)
                                }
                            } else {
                                TasksList(todayTasks: $viewModel.todayTasks) { selectedTask in
                                    viewModel.selectTask(
                                        courseId: selectedTask.taskId,
                                        taskTitle: selectedTask.title,
                                        isCompleted: selectedTask.isCompleted
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.small)
                        
                        VStack(spacing: AppTheme.Spacing.medium) {
                            HStack {
                                Text("Upcoming Deadlines")
                                    .font(AppTheme.textStyle(size: 18, weight: .semibold))
                                    .foregroundColor(AppTheme.Colors.black100)
                                
                                Spacer()
                                
                                Button(action: {
                                    print("View all tapped")
                                }) {
                                    Text("View all")
                                        .font(AppTheme.textStyle(size: 12, weight: .semibold))
                                        .foregroundColor(AppTheme.Colors.purple200)
                                }
                            }
                            
                            if viewModel.upcomingDeadlines.isEmpty {
                                Text("Yaaay! you are done with this month's deadlines")
                                    .font(AppTheme.textStyle(size: 14, weight: .medium))
                                    .foregroundColor(AppTheme.Colors.gray300)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, AppTheme.Spacing.xxLarge)
                            } else {
                                DeadlineList(upcomingDeadlines: $viewModel.upcomingDeadlines)
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.small)
                        
                        SuggestionCard()
                            .padding(.horizontal, AppTheme.Spacing.small)
                    }
                    .padding(.vertical, AppTheme.Spacing.small)
                    .padding(.bottom, 100)
                    .frame(width: geometry.size.width)
                }
                .background(AppTheme.Colors.white100)
            }
        }
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .overlay(
            Group {
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.15).ignoresSafeArea()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.purple200))
                            .scaleEffect(1.5)
                    }
                }
            }
        )
        .task {
            await viewModel.fetchUser()
            await viewModel.fetchDashboardDetails()
        }
    }
}

//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView(viewModel: DashboardViewModel(
//            getDashboardDetailsUseCase: GetDashboardDetailsUseCase(
//                dashboardRepository: DashboardRepository(
//                    remoteDataSource: DashboardRemoteDataSource()
//                )
//            )
//        ))
//    }
//}
