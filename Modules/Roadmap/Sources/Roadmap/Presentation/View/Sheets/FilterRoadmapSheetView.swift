//
//  FilterRoadmapSheetView.swift
//
//

import SwiftUI
import Common

/// Filtering is entirely local against the already-fetched roadmap — see
/// `RoadmapViewmodel.displayedRoadmap`. Courses come from `GetCoursesUseCase` (the API),
/// not a mock list.
struct FilterRoadmapSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: RoadmapViewmodel

    @State private var dateRange: ClosedRange<Date>?
    @State private var selectedCourseIds: Set<String>
    @State private var selectedEventTypes: Set<RoadmapFilterEventType>

    private let rangeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    init(viewModel: RoadmapViewmodel) {
        self.viewModel = viewModel
        _dateRange = State(initialValue: viewModel.filterState.dateRange)
        _selectedCourseIds = State(initialValue: viewModel.filterState.courseIds)
        _selectedEventTypes = State(initialValue: viewModel.filterState.eventTypes)
    }

    private var activeCount: Int {
        (dateRange != nil ? 1 : 0) + selectedCourseIds.count + selectedEventTypes.count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            dragHandle
            header
                .padding(.bottom, AppTheme.Spacing.medium)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                    RoadmapCalendarRangePickerView(range: $dateRange, referenceDate: Date())

                    selectedRangeLabel

                    divider

                    coursesSection

                    divider

                    eventTypesSection
                }
                .padding(.bottom, AppTheme.Spacing.small)
            }

            actionButtons
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.large)
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .presentationDetents([.height(700), .large])
        .presentationDragIndicator(.hidden)
        .onAppear {
            if viewModel.courses.isEmpty {
                viewModel.loadCourses()
            }
        }
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
        .padding(.bottom, AppTheme.Spacing.small)
    }

    private var header: some View {
        HStack {
            Text("Filter Roadmap")
                .font(AppTheme.textStyle(size: 24, weight: .bold))
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

    private var selectedRangeLabel: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
            Text("Selected:")
                .font(AppTheme.textStyle(size: 14, weight: .medium))
                .foregroundColor(AppTheme.Colors.gray300)

            if let dateRange {
                Text("\(rangeFormatter.string(from: dateRange.lowerBound)) – \(rangeFormatter.string(from: dateRange.upperBound))")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.purple200)
            } else {
                Text("No date range selected")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.purple200)
            }
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(AppTheme.Colors.gray100)
            .frame(height: 1)
    }

    private var coursesSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Courses")
                .font(AppTheme.textStyle(size: 14, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            if viewModel.courses.isEmpty {
                Text("No courses added yet")
                    .font(AppTheme.textStyle(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.Colors.gray300)
            } else {
                RoadmapFilterFlowLayout(spacing: AppTheme.Spacing.xxSmall) {
                    ForEach(viewModel.courses, id: \.courseId) { course in
                        RoadmapFilterChipView(
                            title: course.courseName,
                            isSelected: selectedCourseIds.contains(course.courseId),
                            onTap: { toggleCourse(course.courseId) }
                        )
                    }
                }
            }
        }
    }

    private var eventTypesSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("Event Types")
                .font(AppTheme.textStyle(size: 14, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            RoadmapFilterFlowLayout(spacing: AppTheme.Spacing.xxSmall) {
                ForEach(RoadmapFilterEventType.allCases) { type in
                    RoadmapFilterChipView(
                        title: type.rawValue,
                        iconName: type.iconName,
                        isSelected: selectedEventTypes.contains(type),
                        onTap: { toggleEventType(type) }
                    )
                }
            }
        }
    }

    private var actionButtons: some View {
        HStack {
            Button(action: resetFilters) {
                Text("Reset")
                    .font(AppTheme.textStyle(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.black100)
            }

            Spacer()

            Button(action: applyFilters) {
                Text(activeCount > 0 ? "Apply (\(activeCount))" : "Apply")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.white100)
                    .padding(.horizontal, AppTheme.Spacing.large)
                    .padding(.vertical, AppTheme.Spacing.small)
                    .background(
                        Capsule().fill(AppTheme.Colors.purple200)
                    )
            }
        }
        .padding(.top, AppTheme.Spacing.medium)
    }

    private func toggleCourse(_ id: String) {
        if selectedCourseIds.contains(id) {
            selectedCourseIds.remove(id)
        } else {
            selectedCourseIds.insert(id)
        }
    }

    private func toggleEventType(_ type: RoadmapFilterEventType) {
        if selectedEventTypes.contains(type) {
            selectedEventTypes.remove(type)
        } else {
            selectedEventTypes.insert(type)
        }
    }

    private func resetFilters() {
        dateRange = nil
        selectedCourseIds.removeAll()
        selectedEventTypes.removeAll()
    }

    private func applyFilters() {
        viewModel.filterState = RoadmapFilterState(
            dateRange: dateRange,
            courseIds: selectedCourseIds,
            eventTypes: selectedEventTypes
        )
        dismiss()
    }
}

struct FilterRoadmapSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FilterRoadmapSheetView(viewModel: RoadmapViewmodel())
    }
}
