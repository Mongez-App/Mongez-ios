//
//  AddEventSheetView.swift
//
//
//  Created by Claude on 23/07/2026.
//

import SwiftUI
import Common

/// UI only — submitting just dismisses the sheet until AddEventUseCase is wired up.
enum RoadmapEventType: String, CaseIterable {
    case exam = "Exam"
    case quiz = "Quiz"
    case assignment = "Assignment"
    case studySession = "Study Session"
    case deadline = "Deadline"
}

struct AddEventSheetView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var eventType: String = RoadmapEventType.exam.rawValue
    @State private var courseName: String
    @State private var eventDate: Date = Date()

    private let courses: [Course]

    init(courses: [Course] = Course.mockList) {
        self.courses = courses
        _courseName = State(initialValue: courses.first?.courseName ?? "")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            dragHandle
            header

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                    titleField

                    RoadmapDropdownField(
                        title: "Event Type",
                        options: RoadmapEventType.allCases.map(\.rawValue),
                        selection: $eventType
                    )

                    RoadmapDropdownField(
                        title: "Course",
                        options: courses.map(\.courseName),
                        selection: $courseName
                    )

                    dateTimeField
                }
                .padding(.bottom, AppTheme.Spacing.small)
            }

            addButton
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.large)
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .presentationDetents([.height(560), .large])
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
            Text("Add Event")
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

    private var titleField: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text("Title")
                .font(AppTheme.textStyle(size: 14, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            TextField("e.g. Midterm Exam", text: $title)
                .font(AppTheme.textStyle(size: 14))
                .foregroundColor(AppTheme.Colors.black100)
                .padding(AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.2))
                )
        }
    }

    private var dateTimeField: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text("Date & Time")
                .font(AppTheme.textStyle(size: 14, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            HStack {
                DatePicker(
                    "",
                    selection: $eventDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .labelsHidden()
                .accentColor(AppTheme.Colors.purple200)

                Spacer()

                Image("calendar-red")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(AppTheme.Colors.purple200.opacity(0.9))
            }
            .padding(.horizontal, AppTheme.Spacing.xSmall)
            .padding(.vertical, AppTheme.Spacing.xxSmall)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.2))
            )
        }
    }

    private var addButton: some View {
        Button(action: { dismiss() }) {
            Text("Add Event")
                .font(AppTheme.textStyle(size: 16, weight: .medium))
                .foregroundColor(AppTheme.Colors.white100)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.small)
                .background(AppTheme.Colors.purple200)
                .cornerRadius(AppTheme.radius.meduim)
        }
        .padding(.top, AppTheme.Spacing.xxSmall)
    }
}

struct AddEventSheetView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventSheetView()
    }
}
