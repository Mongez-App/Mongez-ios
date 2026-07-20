//
//  SwiftUIView.swift
//
//
//  Created by Ahmed Tarek on 19/07/2026.
//

import SwiftUI
import Common

struct DeadlineList: View {
    //@Binding var upcomingDeadlines: [UpcomingDeadline]
    
    let colors = [AppTheme.Colors.red100, AppTheme.Colors.green100]
    
    var upcomingDeadlines = [
        UpcomingDeadline(
            deadlineId: "dl_881",
            title: "Midterm",
            courseName: "Operating Systems",
            dueText: "4 Days left",
            dueDate: "2026-07-18T23:59:59Z"
        ),
        UpcomingDeadline(
            deadlineId: "dl_882",
            title: "Assignment",
            courseName: "Networks",
            dueText: "Tomorrow",
            dueDate: "2026-07-15T23:59:59Z"
        )
    ]
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            ForEach(upcomingDeadlines.indices, id: \.self) { index in
                DeadlineCard(color: colors[index], upcomingDeadline: upcomingDeadlines[index])
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    DeadlineList()
}
