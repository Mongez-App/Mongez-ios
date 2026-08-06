import SwiftUI
import Common

enum RoadmapEventType: String, CaseIterable {
    case quiz = "quiz"
    case assignment = "assignment"
    case project = "project"
    case midterm = "midterm"
    case exam = "exam"
}

struct AddEventSheetView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var eventType: String = RoadmapEventType.exam.rawValue
    @State private var selectedCourseId: String
    @State private var eventDate: Date = Date()
    @State private var isSubmitting = false
    @State private var errorMessage: String? = nil
    @State private var showError = false

    private let courses: [Course]
    private let onSubmit: (String, String, String, String, Int) async -> Bool

    init(courses: [Course], onSubmit: @escaping (String, String, String, String, Int) async -> Bool) {
        self.courses = courses
        self.onSubmit = onSubmit
        _selectedCourseId = State(initialValue: courses.first?.courseId ?? "")
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
                        options: RoadmapEventType.allCases.map { $0.rawValue.capitalized },
                        selection: Binding(
                            get: { eventType.capitalized },
                            set: { newVal in eventType = newVal.lowercased() }
                        )
                    )

                    RoadmapDropdownField(
                        title: "Course",
                        options: courses.map(\.courseName),
                        selection: Binding(
                            get: { courses.first(where: { $0.courseId == selectedCourseId })?.courseName ?? "" },
                            set: { newName in
                                if let course = courses.first(where: { $0.courseName == newName }) {
                                    selectedCourseId = course.courseId
                                }
                            }
                        )
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
        .disabled(isSubmitting)
        .alert("Error", isPresented: $showError, presenting: errorMessage) { _ in
            Button("OK", role: .cancel) {}
        } message: { msg in
            Text(msg)
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
        Button(action: submit) {
            HStack {
                if isSubmitting {
                    ProgressView()
                        .tint(.white)
                }
                Text("Add Event")
                    .font(AppTheme.textStyle(size: 16, weight: .medium))
            }
            .foregroundColor(AppTheme.Colors.white100)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.small)
            .background(AppTheme.Colors.purple200)
            .cornerRadius(AppTheme.radius.meduim)
        }
        .disabled(isSubmitting || title.trimmingCharacters(in: .whitespaces).isEmpty)
        .padding(.top, AppTheme.Spacing.xxSmall)
    }

    private func submit() {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        isSubmitting = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: eventDate)
        Task {
            let success = await onSubmit(selectedCourseId, eventType.lowercased(), title, dateString, 0)
            await MainActor.run {
                isSubmitting = false
                if success {
                    dismiss()
                } else {
                    errorMessage = "Failed to add event. Please try again."
                    showError = true
                }
            }
        }
    }
}
