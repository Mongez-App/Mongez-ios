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
        HStack(spacing: AppTheme.Spacing.small) {
            ForEach(upcomingDeadlines.indices, id: \.self) { index in
                DeadlineCard(color: colors[index], upcomingDeadline: upcomingDeadlines[index])
            }
            .frame(maxWidth: .infinity)
        }
    }
}

//#Preview {
//    DeadlineList()
//}
