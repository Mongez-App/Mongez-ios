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
        VStack {
            if viewModel.user != nil {
                HeaderView(user: $viewModel.user)
            }
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: AppTheme.Spacing.xLarge) {
                    if viewModel.todayFocus != nil {
                        TodayFocusCard(todayFocus: $viewModel.todayFocus)
                    }
                    
                    if viewModel.progressMetrics != nil {
                        ProgressList(progressMetrics: $viewModel.progressMetrics)
                    }
                    
                    if viewModel.todayTasks != nil {
                        VStack(spacing: AppTheme.Spacing.medium) {
                            HStack {
                                Text("Today's Tasks")
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
                            
                            TasksList(todayTasks: $viewModel.todayTasks) { selectedTask in
                                viewModel.onTaskSelected?(selectedTask.taskId, selectedTask.title)
                            }
                        }
                    }
                    
                    if viewModel.upcomingDeadlines != nil {
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
                            
                            DeadlineList(upcomingDeadlines: $viewModel.upcomingDeadlines)
                        }
                    }
                    
                    SuggestionCard()
                }
                .padding(.horizontal, AppTheme.Spacing.small)
                .padding(.vertical, AppTheme.Spacing.small)
            }
            .background(AppTheme.Colors.white100)
        }
        .background(AppTheme.Colors.white100)
        .onAppear {
            viewModel.fetchUser()
            viewModel.fetchDashboardDetails()
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(viewModel: DashboardViewModel())
    }
}
