//
//  WeekSectionView.swift
//
//
//  Created by Claude on 23/07/2026.
//

import SwiftUI
import Common

struct WeekSectionView: View {
    let week: Week
    let expandedBlockId: String?
    let selectedTab: (String) -> RoadmapDetailTab
    let onToggleBlock: (String) -> Void
    let onSelectTab: (RoadmapDetailTab, String) -> Void

    var body: some View {
        HStack(alignment: .top, spacing: AppTheme.Spacing.small) {
            VStack {
                Circle()
                    .fill(AppTheme.Colors.purple200)
                    .frame(width: 10, height: 10)

                Rectangle()
                    .fill(AppTheme.Colors.gray100)
                    .frame(width: 2)
            }

            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                    Text("Week \(week.weekNumber)")
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)

                    Text("\(week.startDate.toRoadmapDate()) - \(week.endDate.toRoadmapDate())")
                        .font(AppTheme.textStyle(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.Colors.gray300)
                }

                ForEach(week.studyBlocks, id: \.blockId) { block in
                    StudyBlockCardView(
                        block: block,
                        isExpanded: expandedBlockId == block.blockId,
                        selectedTab: selectedTab(block.blockId),
                        onToggle: { onToggleBlock(block.blockId) },
                        onSelectTab: { onSelectTab($0, block.blockId) }
                    )
                }
            }
            .padding(.bottom, AppTheme.Spacing.medium)
        }
    }
}
