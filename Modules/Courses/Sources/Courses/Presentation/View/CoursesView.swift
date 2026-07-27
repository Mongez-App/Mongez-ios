import SwiftUI
import Common

public struct CoursesView: View {
    @ObservedObject public var viewModel: CoursesViewModel

    public init(viewModel: CoursesViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            AppTheme.Colors.white100.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                headerSection
                searchSection

                if viewModel.isLoading && viewModel.courses.isEmpty {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.2)
                        Spacer()
                    }
                    Spacer()
                } else if let error = viewModel.errorMessage, viewModel.courses.isEmpty {
                    Spacer()
                    VStack(spacing: AppTheme.Spacing.small) {
                        Image(systemName: "wifi.exclamationmark")
                            .font(.system(size: 40))
                            .foregroundColor(AppTheme.Colors.gray200)
                        Text(error)
                            .font(AppTheme.textStyle(size: 14, weight: .regular))
                            .foregroundColor(AppTheme.Colors.gray200)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await viewModel.loadCourses() }
                        }
                        .font(AppTheme.textStyle(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.purple200)
                    }
                    .padding()
                    Spacer()
                } else if viewModel.filteredCourses.isEmpty && !viewModel.isLoading {
                    EmptyCoursesView(
                        isSearching: !viewModel.searchText.isEmpty,
                        onAddCourse: {
                            viewModel.showAddCourseSheet = true
                        }
                    )
                } else {
                    coursesList
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddCourseSheet) {
            AddCourseSheet(viewModel: viewModel)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .overlay {
            if viewModel.showDeleteConfirmation {
                DeleteConfirmationDialog(
                    courseName: viewModel.courseToDelete?.name ?? "",
                    onConfirm: { viewModel.confirmDelete() },
                    onCancel: { viewModel.cancelDelete() }
                )
            }
        }
        .task {
            await viewModel.loadCourses()
        }
        .refreshable {
            await viewModel.loadCourses()
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }

    private var headerSection: some View {
        HStack {
            Text("My Courses")
                .font(AppTheme.textStyle(size: 28, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            Spacer()

            Button(action: {
                viewModel.resetAddCourseForm()
                viewModel.showAddCourseSheet = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.purple200)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(AppTheme.Colors.white100)
                            .appShadow(opacity: 0.7, radius: 2, y: 0)
                    )
            }
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.top, AppTheme.Spacing.medium)
        .padding(.bottom, AppTheme.Spacing.small)
    }

    private var searchSection: some View {
        HStack(spacing: AppTheme.Spacing.xxSmall) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.Colors.gray200)
                .font(.system(size: 16))

            TextField("Search courses...", text: $viewModel.searchText)
                .font(AppTheme.textStyle(size: 14, weight: .regular))
                .foregroundColor(AppTheme.Colors.black100)

            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppTheme.Colors.gray200)
                        .font(.system(size: 14))
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xSmall)
        .padding(.vertical, AppTheme.Spacing.xSmall)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .stroke(AppTheme.Colors.gray100, lineWidth: 1)
        )
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.small)
    }

    private var coursesList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: AppTheme.Spacing.medium) {
                ForEach(viewModel.filteredCourses) { course in
                    Button(action: {
                        viewModel.selectCourse(id: course.id)
                    }) {
                        CourseCardView(
                            course: course,
                            onDelete: {
                                viewModel.requestDelete(course: course)
                            }
                        )
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, AppTheme.Spacing.large)
            .padding(.top, AppTheme.Spacing.xxSmall)
            .padding(.bottom, AppTheme.Spacing.large)
        }
    }
}

#if DEBUG
struct MockCoursesRepository: CoursesRepositoryProtocol {
    func fetchCourses() async throws -> [Course] {
        return [
            Course(id: "1", name: "Operating Systems", courseCode: "CS301", description: "Introduction to OS", completionPercentage: 75.0, materialCount: 5),
            Course(id: "2", name: "Data Structures", courseCode: "CS201", description: "Learn about trees and graphs", completionPercentage: 30.0, materialCount: 3),
            Course(id: "3", name: "Algorithms", courseCode: "CS202", description: "Design and analysis", completionPercentage: 10.0, materialCount: 10)
        ]
    }

    func createCourse(name: String, courseCode: String, imageUrl: String?, startDate: Date, endDate: Date?, examDate: Date, hasMaterials: Bool) async throws -> Course {
        return Course(name: name, courseCode: courseCode)
    }

    func deleteCourse(id: String) async throws {}

    func addMaterialMetadata(courseId: String, fileName: String, contentType: String, fileSizeBytes: Int, pageCount: Int?) async throws -> Material {
        return Material(fileName: fileName, contentType: contentType, fileSizeBytes: fileSizeBytes)
    }

    func uploadMaterialFile(uploadId: String, fileData: Data, fileName: String, contentType: String) async throws {}

    func addCourseFromURL(url: String) async throws -> Course {
        return Course(name: "Online Course")
    }
}

struct MockCloudinaryService: CloudinaryServiceProtocol {
    func uploadImage(imageData: Data) async throws -> String {
        return "https://mock-image-url.com/image.jpg"
    }
}

extension CoursesViewModel {
    static var preview: CoursesViewModel {
        let repo = MockCoursesRepository()
        let cloudinary = MockCloudinaryService()
        return CoursesViewModel(
            fetchCoursesUseCase: FetchCoursesUseCase(repository: repo),
            addCourseUseCase: AddCourseUseCase(repository: repo, cloudinaryService: cloudinary),
            deleteCourseUseCase: DeleteCourseUseCase(repository: repo),
            addCourseFromURLUseCase: AddCourseFromURLUseCase(repository: repo)
        )
    }
}

struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CoursesView(viewModel: CoursesViewModel.preview)
    }
}
#endif

