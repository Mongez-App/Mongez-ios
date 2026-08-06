//
//  TasksList.swift
//
//  Created by Ahmed Tarek on 20/07/2026.
//

import SwiftUI
import Common

struct TasksList: View {
    @Binding var todayTasks: [TodayTask]
    var limit: Int? = 3
    var onTaskTap: ((TodayTask) -> Void)?
    
    private var tasksToShow: [TodayTask] {
        if let limit = limit {
            return Array(todayTasks.prefix(limit))
        } else {
            return todayTasks
        }
    }
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.small) {
            ForEach(tasksToShow, id: \.taskId) { task in
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
