//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 19/07/2026.
//

import SwiftUI
import Common

struct ProgressList: View {
    @Binding var progressMetrics: ProgressMetrics?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.small) {
                ProgressCard(color: AppTheme.Colors.blue100,
                             title: "Today's Goal",
                             numerator: progressMetrics!.todayCompletedTasks,
                             denominator: progressMetrics!.todayTotalTasks,
                             unit: "Tasks")
                
                ProgressCard(color: AppTheme.Colors.green100,
                             title: "Weekly Progress",
                             numerator: progressMetrics!.weeklyHoursCompleted,
                             denominator: progressMetrics!.monthlyHoursGoal,
                             unit: "Hours")
                
                ProgressCard(color: AppTheme.Colors.purple100,
                             title: "Monthly Progress",
                             numerator: progressMetrics!.monthlyHoursCompleted,
                             denominator: progressMetrics!.monthlyHoursGoal,
                             unit: "Hours")
            }
        }
    }
}

//#Preview {
//    ProgressList()
//}
