//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 20/07/2026.
//

import SwiftUI
import Common

struct TasksList: View {
    @Binding var todayTasks: [TodayTask]
    var onTaskTap: ((TodayTask) -> Void)?
    var body: some View {
        VStack(spacing: AppTheme.Spacing.small) {
            ForEach(todayTasks.prefix(3), id: \.taskId) { task in
                TaskCard(task: task) {
                    onTaskTap?(task)
                }
            }
        }
    }
}

//#Preview {
//    TasksList()
//}
