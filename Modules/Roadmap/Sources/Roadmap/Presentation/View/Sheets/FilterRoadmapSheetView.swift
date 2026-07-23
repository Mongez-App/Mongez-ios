//
//  FilterRoadmapSheetView.swift
//
//
//  Created by Claude on 23/07/2026.
//

import SwiftUI
import Common

/// UI only — selections aren't applied to the roadmap list yet.
enum RoadmapStatusFilter: String, CaseIterable {
    case all = "All"
    case completed = "Completed"
    case inProgress = "In Progress"
}

struct FilterRoadmapSheetView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedStatus: RoadmapStatusFilter = .all
    @State private var selectedCourseNames: Set<String> = []

    private let courses: [Course]

    init(courses: [Course] = Course.mockList) {
        self.courses = courses
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
            dragHandle
            header
            statusSection
            coursesSection

            Spacer(minLength: 0)

            actionButtons
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.large)
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .presentationDetents([.height(460), .large])
        .presentationDragIndicator(.hidden)
    }

    private var dragHandle: some View {
        HStack {
            Spacer()
            Capsule()
                .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.15))
                .frame(width: 48, height: 5)
            Spacer()
        }
        .padding(.top, AppTheme.Spacing.small)
    }

    private var header: some View {
        HStack {
            Text("Filter Roadmap")
                .font(AppTheme.textStyle(size: 22, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            Spacer()

            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.gray200)
                    .frame(width: 28, height: 28)
                    .background(
                        Circle()
                            .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.3))
                    )
            }
        }
    }

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Status")
                .font(AppTheme.textStyle(size: 14, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            RoadmapFilterChipsView(
                options: RoadmapStatusFilter.allCases.map(\.rawValue),
                isSelected: { $0 == selectedStatus.rawValue },
                onTap: { raw in
                    if let status = RoadmapStatusFilter(rawValue: raw) {
                        selectedStatus = status
                    }
                }
            )
        }
    }

    private var coursesSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Courses")
                .font(AppTheme.textStyle(size: 14, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            RoadmapFilterChipsView(
                options: courses.map(\.courseName),
                isSelected: { selectedCourseNames.contains($0) },
                onTap: { name in
                    if selectedCourseNames.contains(name) {
                        selectedCourseNames.remove(name)
                    } else {
                        selectedCourseNames.insert(name)
                    }
                }
            )
        }
    }

    private var actionButtons: some View {
        HStack(spacing: AppTheme.Spacing.medium) {
            Button {
                selectedStatus = .all
                selectedCourseNames.removeAll()
            } label: {
                Text("Reset")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.medium)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray200, opacity: 0.2))
                    )
            }

            Button {
                dismiss()
            } label: {
                Text("Apply Filters")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.white100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.medium)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.Colors.purple200)
                            .appShadow(opacity: 0.4, radius: 12, y: 6)
                    )
            }
        }
    }
}

struct FilterRoadmapSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FilterRoadmapSheetView()
    }
}
