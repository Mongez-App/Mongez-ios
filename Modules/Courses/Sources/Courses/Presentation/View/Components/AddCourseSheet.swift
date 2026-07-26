import SwiftUI
import Common
import PhotosUI

struct AddCourseSheet: View {
    @ObservedObject var viewModel: CoursesViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {

                    HStack {
                        Text("Add New Course")
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
                    .padding(.top, AppTheme.Spacing.small)

                    HStack(spacing: 0) {
                        tabButton(
                            title: "Online Course",
                            icon: "link",
                            isSelected: viewModel.addCourseTab == .onlineCourse,
                            action: { viewModel.addCourseTab = .onlineCourse }
                        )

                        tabButton(
                            title: "Upload Material",
                            icon: "folder",
                            isSelected: viewModel.addCourseTab == .uploadMaterial,
                            action: { viewModel.addCourseTab = .uploadMaterial }
                        )
                    }
                    .padding(AppTheme.Spacing.xxxSmall)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                            .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.15))
                    )

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                            switch viewModel.addCourseTab {
                            case .onlineCourse:
                                onlineCourseForm
                            case .uploadMaterial:
                                uploadMaterialForm
                            }
                        }
                    }

                    if let error = viewModel.createError {
                        Text(error)
                            .font(AppTheme.textStyle(size: 12, weight: .medium))
                            .foregroundColor(AppTheme.Colors.red100)
                            .padding(.horizontal, AppTheme.Spacing.xxSmall)
                    }

                    Spacer()

                    Button(action: {
                        Task {
                            await viewModel.addCourse()
                            if viewModel.createError == nil {
                                dismiss()
                            }
                        }
                    }) {
                        Text(viewModel.isCreatingCourse ? "Creating..." : "Add Course")
                            .font(AppTheme.textStyle(size: 16, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.white100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.Spacing.small)
                            .background(
                                viewModel.canAddCourse && !viewModel.isCreatingCourse
                                    ? AppTheme.Colors.purple200
                                    : AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.4)
                            )
                            .cornerRadius(AppTheme.radius.meduim)
                            .appShadow(opacity: 0.3, radius: 8, y: 4)
                    }
                    .disabled(!viewModel.canAddCourse || viewModel.isCreatingCourse)
                    .padding(.bottom, AppTheme.Spacing.small)
                }
                .padding(.horizontal, AppTheme.Spacing.large)
                .background(AppTheme.Colors.white100.ignoresSafeArea())
                .navigationBarHidden(true)

                if viewModel.isCreatingCourse {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    VStack(spacing: AppTheme.Spacing.small) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(AppTheme.Colors.white100)
                        Text("Creating course...")
                            .font(AppTheme.textStyle(size: 14, weight: .medium))
                            .foregroundColor(AppTheme.Colors.white100)
                    }
                    .padding(AppTheme.Spacing.large)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                            .fill(AppTheme.Colors.black100.opacity(0.8))
                    )
                }
            }
        }
        .fileImporter(
            isPresented: $viewModel.showFileImporter,
            allowedContentTypes: [.pdf, .presentation, .spreadsheet, .plainText, .data],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                for url in urls {
                    viewModel.addMaterialFromURL(url)
                }
            case .failure(let error):
                print("File import error: \(error)")
            }
        }
    }

    private var onlineCourseForm: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            formLabel("Course URL")

            TextField("https://example.com/course-link", text: $viewModel.courseURL)
                .font(AppTheme.textStyle(size: 14, weight: .regular))
                .foregroundColor(AppTheme.Colors.black100)
                .padding(AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.2))
                )
                .autocapitalization(.none)
                .keyboardType(.URL)

            deadlinePicker
        }
    }

    private var uploadMaterialForm: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Group {

                formLabel("Course Name")
                formTextField("e.g. Operating Systems", text: $viewModel.courseName)

                formLabel("Course Code (Optional)")
                formTextField("e.g. CS301", text: $viewModel.courseCode)

                formLabel("Description (Optional)")
                formTextField("Brief description of the course", text: $viewModel.courseDescription)

                datePicker(label: "Start Date", selection: $viewModel.courseStartDate)
                deadlinePicker
            }

            Group {

                formLabel("Thumbnail")
                thumbnailPicker

                HStack {
                    formLabel("Course Material")
                    Text("(at least 1 required)")
                        .font(AppTheme.textStyle(size: 12, weight: .regular))
                        .foregroundColor(AppTheme.Colors.red100)
                }

                Button(action: { viewModel.showFileImporter = true }) {
                    VStack(spacing: AppTheme.Spacing.xxSmall) {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                        Text("Upload Materials (PDF, PPT, DOC)")
                            .font(AppTheme.textStyle(size: 14, weight: .regular))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.large)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(AppTheme.Colors.gray100)
                    )
                    .foregroundColor(AppTheme.Colors.purple200)
                }

                if !viewModel.selectedMaterials.isEmpty {
                    ForEach(Array(viewModel.selectedMaterials.enumerated()), id: \.element.id) { index, material in
                        materialRow(material: material, index: index)
                    }
                }
            }
        }
    }

    private var thumbnailPicker: some View {
        PhotosPicker(
            selection: $viewModel.selectedImageItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            if let imageData = viewModel.selectedImageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .stroke(AppTheme.Colors.gray100, lineWidth: 1)
                    )
            } else if !viewModel.courseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {

                ZStack {
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .fill(
                            LinearGradient(
                                colors: [
                                    AppTheme.Colors.purple200.opacity(0.2),
                                    AppTheme.Colors.purple200.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    VStack(spacing: AppTheme.Spacing.xxSmall) {
                        Text(viewModel.courseInitials)
                            .font(AppTheme.textStyle(size: 36, weight: .bold))
                            .foregroundColor(AppTheme.Colors.purple200)

                        Text("Tap to upload image")
                            .font(AppTheme.textStyle(size: 11, weight: .regular))
                            .foregroundColor(AppTheme.Colors.gray200)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
            } else {

                VStack(spacing: AppTheme.Spacing.xxSmall) {
                    Image(systemName: "photo")
                        .font(.system(size: 28))
                        .foregroundColor(AppTheme.Colors.green100)

                    Text("Upload cover image")
                        .font(AppTheme.textStyle(size: 13, weight: .medium))
                        .foregroundColor(AppTheme.Colors.black100)

                    Text("PNG or JPG, up to 5 MB")
                        .font(AppTheme.textStyle(size: 11, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray200)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.gray100, style: StrokeStyle(lineWidth: 1, dash: [6, 3]))
                )
            }
        }
    }

    private func materialRow(material: SelectedMaterial, index: Int) -> some View {
        HStack(spacing: AppTheme.Spacing.xxSmall) {

            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.red100, opacity: 0.1))
                    .frame(width: 36, height: 36)

                Text(fileExtension(for: material.fileName).uppercased())
                    .font(AppTheme.textStyle(size: 9, weight: .bold))
                    .foregroundColor(AppTheme.Colors.red100)
            }

            Text(material.fileName)
                .font(AppTheme.textStyle(size: 13, weight: .regular))
                .foregroundColor(AppTheme.Colors.black100)
                .lineLimit(1)

            Spacer()

            Text(formatFileSize(material.fileSizeBytes))
                .font(AppTheme.textStyle(size: 11, weight: .regular))
                .foregroundColor(AppTheme.Colors.gray200)

            Button(action: { viewModel.removeMaterial(at: index) }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(AppTheme.Colors.gray200)
            }
        }
        .padding(AppTheme.Spacing.xxSmall)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .stroke(AppTheme.Colors.gray100, lineWidth: 1)
        )
    }

    private var deadlinePicker: some View {
        datePicker(label: "Deadline (Exam Date)", selection: $viewModel.courseDeadline)
    }

    private func datePicker(label: String, selection: Binding<Date>) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            formLabel(label)

            HStack {
                DatePicker(
                    "",
                    selection: selection,
                    displayedComponents: .date
                )
                .labelsHidden()
                .accentColor(AppTheme.Colors.purple200)

                Spacer()

                Image(systemName: "calendar")
                    .foregroundColor(AppTheme.Colors.purple200)
                    .font(.system(size: 18))
            }
            .padding(.horizontal, AppTheme.Spacing.xSmall)
            .padding(.vertical, AppTheme.Spacing.xxSmall)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.2))
            )
        }
    }

    private func formLabel(_ text: String) -> some View {
        Text(text)
            .font(AppTheme.textStyle(size: 14, weight: .bold))
            .foregroundColor(AppTheme.Colors.black100)
    }

    private func formTextField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .font(AppTheme.textStyle(size: 14, weight: .regular))
            .foregroundColor(AppTheme.Colors.black100)
            .padding(AppTheme.Spacing.xSmall)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.2))
            )
    }

    private func tabButton(title: String, icon: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.xxxSmall) {
                Image(systemName: icon)
                    .font(.system(size: 13))

                Text(title)
                    .font(AppTheme.textStyle(size: 13, weight: .medium))
            }
            .foregroundColor(isSelected ? AppTheme.Colors.purple200 : AppTheme.Colors.gray200)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.xxSmall)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .fill(isSelected ? AppTheme.Colors.white100 : Color.clear)
                    .appShadow(opacity: isSelected ? 0.05 : 0, radius: 4, y: 1)
            )
        }
    }

    private func fileExtension(for fileName: String) -> String {
        let components = fileName.split(separator: ".")
        return components.count > 1 ? String(components.last!) : "FILE"
    }

    private func formatFileSize(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}

#if DEBUG
struct AddCourseSheet_Previews: PreviewProvider {
    static var previews: some View {
        AddCourseSheet(viewModel: CoursesViewModel.preview)
    }
}
#endif

