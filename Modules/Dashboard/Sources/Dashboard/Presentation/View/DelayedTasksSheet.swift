//
//  DelayedTasksSheet.swift
//  Dashboard
//
//  Created by Extern Dev
//

import SwiftUI
import Common

/// Proactive alert presented on the dashboard when there are overdue tasks.
/// The user can resolve each task (mark done / shift to today) or apply a bulk action.
public struct DelayedTasksSheet: View {
    @ObservedObject var viewModel: DashboardViewModel
    @Environment(\.dismiss) private var dismiss

    public init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            header

            if viewModel.delayedTasks.isEmpty {
                emptyState
            } else {
                taskList
            }

            if viewModel.delayedErrorMessage != nil {
                Text(viewModel.delayedErrorMessage ?? "")
                    .font(AppTheme.textStyle(size: 13))
                    .foregroundColor(AppTheme.Colors.red100)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.small)
                    .padding(.top, AppTheme.Spacing.xxSmall)
            }

            bulkActions
        }
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .disabled(viewModel.isRescheduling)
        .overlay {
            if viewModel.isRescheduling {
                ZStack {
                    Color.black.opacity(0.15).ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.purple200))
                        .scaleEffect(1.4)
                }
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                Text("Delayed Tasks")
                    .font(AppTheme.textStyle(size: 22, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)

                Text("You have overdue tasks. Choose how to handle them.")
                    .font(AppTheme.textStyle(size: 14))
                    .foregroundColor(AppTheme.Colors.gray300)
            }
            Spacer()
        }
        .padding(AppTheme.Spacing.medium)
        .background(AppTheme.Colors.white100)
        .overlay(alignment: .bottom) {
            Rectangle().frame(height: 1).foregroundColor(AppTheme.Colors.gray100)
        }
        .padding(.top, AppTheme.Spacing.small)
    }

    private var taskList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: AppTheme.Spacing.small) {
                ForEach(viewModel.delayedTasks) { task in
                    taskRow(for: task)
                }
            }
            .padding(AppTheme.Spacing.small)
        }
    }

    private func taskRow(for task: DelayedTask) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(AppTheme.textStyle(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .lineLimit(2)

                if let course = task.courseName, !course.isEmpty {
                    Text(course)
                        .font(AppTheme.textStyle(size: 13))
                        .foregroundColor(AppTheme.Colors.gray300)
                }

                if let due = task.dueText, !due.isEmpty {
                    Text(due)
                        .font(AppTheme.textStyle(size: 12))
                        .foregroundColor(AppTheme.Colors.red100)
                }
            }

            HStack(spacing: AppTheme.Spacing.xxSmall) {
                actionButton(title: DelayedAction.markCompleted.title,
                             color: AppTheme.Colors.green100,
                             titleColor: AppTheme.Colors.white100) {
                    Task { await viewModel.applyAction(.markCompleted, to: task) }
                }

                actionButton(title: DelayedAction.shiftToToday.title,
                             color: AppTheme.Colors.white100,
                             titleColor: AppTheme.Colors.purple200,
                             bordered: true) {
                    Task { await viewModel.applyAction(.shiftToToday, to: task) }
                }
            }
        }
        .padding(AppTheme.Spacing.small)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .fill(AppTheme.Colors.white100)
                .appShadow(opacity: 0.6, radius: 3, y: 0)
        )
    }

    private func actionButton(title: String, color: Color, titleColor: Color, bordered: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.textStyle(size: 13, weight: .bold))
                .foregroundColor(titleColor)
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .fill(color)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                .stroke(bordered ? AppTheme.Colors.gray200 : Color.clear, lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var bulkActions: some View {
        VStack(spacing: AppTheme.Spacing.xSmall) {
            if !viewModel.delayedTasks.isEmpty {
                Text("Apply to all (\(viewModel.delayedTasks.count))")
                    .font(AppTheme.textStyle(size: 14, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
            }

            HStack(spacing: AppTheme.Spacing.small) {
                bulkButton(title: "Mark All Done", fill: AppTheme.Colors.red100.opacity(0.12), foreground: AppTheme.Colors.red100, action: markCompletedAll)
                bulkButton(title: "Move All to Today", fill: AppTheme.Colors.purple200, foreground: AppTheme.Colors.white100, action: shiftToToday)
            }

            Button("Close") { dismiss() }
                .font(AppTheme.textStyle(size: 15, weight: .semibold))
                .foregroundColor(AppTheme.Colors.gray300)
                .padding(.top, AppTheme.Spacing.xxSmall)
        }
        .padding(AppTheme.Spacing.medium)
        .background(AppTheme.Colors.white100)
        .overlay(alignment: .top) {
            Rectangle().frame(height: 1).foregroundColor(AppTheme.Colors.gray100)
        }
    }

    private func bulkButton(title: String, fill: Color, foreground: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.textStyle(size: 14, weight: .bold))
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .foregroundColor(foreground)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .fill(fill)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func markCompletedAll() {
        Task { await viewModel.applyBulkAction(.markCompleted) }
    }

    private func shiftToToday() {
        Task { await viewModel.applyBulkAction(.shiftToToday) }
    }

    private var emptyState: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(AppTheme.Colors.green100)
            Text("All caught up!")
                .font(AppTheme.textStyle(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
            Text("You have no pending tasks from previous days.")
                .font(AppTheme.textStyle(size: 14))
                .foregroundColor(AppTheme.Colors.gray300)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}