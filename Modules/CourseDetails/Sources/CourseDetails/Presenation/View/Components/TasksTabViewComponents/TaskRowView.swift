//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct TaskRowView: View {
    public let task: CourseTask
    
    public init(task: CourseTask) {
        self.task = task
    }
    
    private func getPriorityColor(for priority: CourseTask.Priority) -> Color {
        switch priority {
        case .high: return AppTheme.Colors.red100
        case .medium: return AppTheme.Colors.yellow100
        case .low: return AppTheme.Colors.green100
        }
    }
    
    public var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            if task.isCompleted {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.green100)
                        .frame(width: 24, height: 24)
                    
                    Image("done")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
            } else {
                Circle()
                    .stroke(AppTheme.Colors.gray200, lineWidth: 1.5)
                    .frame(width: 28, height: 28)
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                Text(task.title)
                    .font(AppTheme.textStyle(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .padding(.vertical, AppTheme.Spacing.xxxSmall)
            
                HStack(spacing: AppTheme.Spacing.xxxSmall) {
                    Text("\(task.durationMinutes) min")
                        .font(AppTheme.textStyle(size: 14))
                        .foregroundColor(AppTheme.Colors.gray300)
                    Text("•")
                        .font(AppTheme.textStyle(size: 14))
                        .foregroundColor(AppTheme.Colors.gray300)
                    Text(task.priority.rawValue)
                        .font(AppTheme.textStyle(size: 12, weight: .bold))
                        .foregroundColor(getPriorityColor(for: task.priority))
                    
                    if let dateString = task.date {
                        Text("•")
                            .font(AppTheme.textStyle(size: 14))
                            .foregroundColor(AppTheme.Colors.gray300)
                        Text(formatDate(dateString))
                            .font(AppTheme.textStyle(size: 14))
                            .foregroundColor(AppTheme.Colors.gray300)
                    }
                }
            }
            Spacer()
        }
        .padding(AppTheme.Spacing.small)
        .padding(.vertical, AppTheme.Spacing.xxxSmall)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .fill(AppTheme.Colors.white100)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                        .stroke(AppTheme.Colors.gray100, lineWidth: 1.5)
                )
        )
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
        return dateString
    }
}
