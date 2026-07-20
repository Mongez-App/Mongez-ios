//
//  SwiftUIView.swift
//
//
//  Created by Ahmed Tarek on 20/07/2026.
//

import SwiftUI
import Common

struct TaskCard: View {
    var task: Task?
    
    private var priorityColor: Color {
        switch task!.priority.uppercased() {
        case "HIGH":
            return AppTheme.Colors.red100
        case "MEDIUM":
            return AppTheme.Colors.yellow100
        case "LOW":
            return AppTheme.Colors.green100
        default:
            return AppTheme.Colors.gray200
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            
            if task!.isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(AppTheme.Colors.green100)
            } else {
                Circle()
                    .stroke(AppTheme.Colors.gray100, lineWidth: 2)
                    .frame(width: 24, height: 24)
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                Text(task!.title)
                    .font(AppTheme.textStyle(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                
                HStack(spacing: AppTheme.Spacing.xxxSmall) {
                    Text("\(task!.durationMinutes) min")
                        .font(AppTheme.textStyle(size: 11, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray200)
                    
                    Text("•")
                        .font(.system(size: 20))
                        .foregroundColor(AppTheme.Colors.gray200)
                    
                    Text(task!.priority.uppercased())
                        .font(AppTheme.textStyle(size: 11, weight: .bold))
                        .foregroundColor(priorityColor)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, AppTheme.radius.meduim)
        .frame(maxWidth: .infinity, minHeight: 75, maxHeight: 75)
        .background(AppTheme.Colors.white100)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.meduim))
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .stroke(AppTheme.Colors.gray100, lineWidth: 1)
        )
    }
}


//#Preview {
//    TaskCard()
//}
