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
            ForEach(todayTasks.indices.prefix(3), id: \.self) { index in
                TaskCard(task: todayTasks[index]) {
                    onTaskTap?(todayTasks[index])
                }
            }
        }
    }
}

//#Preview {
//    TasksList()
//}
