//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 19/07/2026.
//

import SwiftUI
import Common

struct DeadlineCard: View {
    var color: Color
    var upcomingDeadline: UpcomingDeadline
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(upcomingDeadline.courseName)")
                    .font(AppTheme.textStyle(size: 12, weight: .medium))
                    .foregroundColor(color)
                    .padding(.bottom, AppTheme.Spacing.xxxSmall)
                
                Text("\(upcomingDeadline.title)")
                    .font(AppTheme.textStyle(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .padding(.bottom, AppTheme.Spacing.xSmall)
                
                Text("\(upcomingDeadline.dueText)")
                    .font(AppTheme.textStyle(size: 12, weight: .medium))
                    .foregroundColor(color)
            }
            
            Spacer()
            
            Image("calendar-red")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(color)
                .padding(AppTheme.Spacing.xSmall)
                .background(color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))
        }
        .padding(AppTheme.Spacing.xSmall)
        .frame(height: 90)
        .frame(minWidth: 165, alignment: .leading)
        .background(AppTheme.Colors.white100)
        .cornerRadius(AppTheme.radius.small)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .stroke(color.opacity(0.4), lineWidth: 1)
        )
    }
}

//#Preview {
//    DeadlineCard(color: AppTheme.Colors.red100)
//}

