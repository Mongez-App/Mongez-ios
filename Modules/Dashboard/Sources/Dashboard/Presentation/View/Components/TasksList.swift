//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 20/07/2026.
//

import SwiftUI
import Common

struct TasksList: View {
    //@Binding var todayTasks: [Task]
    
    var todayTasks = [
        Task(
            taskId: "task_001",
            title: "Read Chapter 4",
            durationMinutes: 45,
            priority: "HIGH",
            isCompleted: true
        ),
        Task(
            taskId: "task_002",
            title: "Practice DFS Problems",
            durationMinutes: 30,
            priority: "MEDIUM",
            isCompleted: false
        ),
        Task(
            taskId: "task_003",
            title: "Finish Quiz",
            durationMinutes: 20,
            priority: "LOW",
            isCompleted: false
        )
    ]
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.small) {
            ForEach(todayTasks.indices.prefix(3), id: \.self) { index in
                TaskCard(task: todayTasks[index])
            }
        }
    }
}

#Preview {
    TasksList()
}
