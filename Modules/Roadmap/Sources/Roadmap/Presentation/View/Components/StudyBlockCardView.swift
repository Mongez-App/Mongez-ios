//
//  StudyBlockCardView.swift
//
//
//  Created by Claude on 23/07/2026.
//

import SwiftUI
import Common

struct StudyBlockCardView: View {
    let block: StudyBlock
    let isExpanded: Bool
    let selectedTab: RoadmapDetailTab
    let onToggle: () -> Void
    let onSelectTab: (RoadmapDetailTab) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            HStack(spacing: AppTheme.Spacing.small) {
                pill
                RoadmapStatusIndicator(isCompleted: block.isCompleted)
            }

            if isExpanded {
                expandedContent
            }
        }
    }

    private var pill: some View {
        HStack {
            Text(block.courseName)
                .font(AppTheme.textStyle(size: 16, weight: .semibold))
                .foregroundColor(AppTheme.Colors.white100)
                .padding(.vertical, AppTheme.Spacing.xxxSmall)

            Spacer()

            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.Colors.white100)
        }
        .padding(.horizontal, AppTheme.Spacing.small)
        .padding(.vertical, AppTheme.Spacing.xSmall)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .fill(StudyBlockColor.color(for: block.blockId))
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onToggle)
    }

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            RoadmapSegmentedTabView(selection: Binding(
                get: { selectedTab },
                set: onSelectTab
            ))

            switch selectedTab {
            case .events:
                if block.events.isEmpty {
                    RoadmapEmptyStateView(message: "No events scheduled for this block yet.")
                } else {
                    ForEach(Array(block.events.enumerated()), id: \.offset) { _, event in
                        RoadmapEntryCardView(
                            title: event.title,
                            subtitle: event.eventType,
                            trailingText: event.eventDate
                        )
                    }
                }

            case .tasks:
                if block.tasks.isEmpty {
                    RoadmapEmptyStateView(message: "No tasks scheduled for this block yet.")
                } else {
                    ForEach(Array(block.tasks.enumerated()), id: \.offset) { _, task in
                        RoadmapEntryCardView(
                            title: task.topic,
                            subtitle: "\(task.durationMinutes) min",
                            trailingText: task.taskDate
                        )
                    }
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xxxSmall)
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}
