//
//  RoadmapStatusIndicator.swift
//
//
//  Created by Claude on 23/07/2026.
//

import SwiftUI
import Common

/// Purely decorative completion marker — it must never look or behave like a checkbox,
/// completion is driven by the study block's own data, not by tapping this circle.
/// Renders nothing when the block isn't completed yet — there's nothing useful to show.
struct RoadmapStatusIndicator: View {
    let isCompleted: Bool

    var body: some View {
        Group {
            if isCompleted {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.green100)
                        .frame(width: 24, height: 24)

                    Image("done")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}
