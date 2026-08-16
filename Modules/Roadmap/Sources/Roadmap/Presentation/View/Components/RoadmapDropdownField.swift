//
//  RoadmapDropdownField.swift
//
//
//  Created by Claude on 23/07/2026.
//

import SwiftUI
import Common

/// Labeled dropdown field — reused for both "Event Type" and "Course" in the Add Event form.
struct RoadmapDropdownField: View {
    let title: LocalizedStringKey
    let options: [String]
    @Binding var selection: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text(title)
                .font(AppTheme.textStyle(size: 14, weight: .medium))
                .foregroundColor(AppTheme.Colors.black100)

            Menu {
                ForEach(options, id: \.self) { option in
                    Button {
                        selection = option
                    } label: {
                        if option == selection {
                            Label(option, systemImage: "checkmark")
                        } else {
                            Text(option)
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selection)
                        .font(AppTheme.textStyle(size: 14))
                        .foregroundColor(AppTheme.Colors.black100)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(AppTheme.textStyle(size: 12, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.gray300)
                }
                .padding(AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.2))
                )
            }
            .buttonStyle(.plain)
        }
    }
}
