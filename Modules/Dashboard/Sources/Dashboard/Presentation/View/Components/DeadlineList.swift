//
//  SwiftUIView.swift
//
//
//  Created by Ahmed Tarek on 19/07/2026.
//

import SwiftUI
import Common

struct DeadlineList: View {
    @Binding var upcomingDeadlines: [UpcomingDeadline]
    
    let colors = [AppTheme.Colors.red100, AppTheme.Colors.green100]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.small) {
                ForEach(Array(upcomingDeadlines.enumerated()).prefix(2), id: \.element.deadlineId) { index, upcomingDeadline in
                    DeadlineCard(color: colors[index % colors.count], upcomingDeadline: upcomingDeadline)
                }
            }
        }
    }
}

//#Preview {
//    DeadlineList()
//}
