//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 20/07/2026.
//

import SwiftUI
import Common

struct TasksList: View {
    @Binding var todayTasks: [Task]?
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.small) {
            ForEach(todayTasks!.indices.prefix(3), id: \.self) { index in
                TaskCard(task: todayTasks![index])
            }
        }
    }
}

//#Preview {
//    TasksList()
//}
