import Foundation
import Combine
import SwiftUI
import PhotosUI

public struct SelectedMaterial: Identifiable, Equatable {
    public let id = UUID()
    public let fileName: String
    public let fileData: Data
    public let contentType: String
    public let fileSizeBytes: Int

    public static func == (lhs: SelectedMaterial, rhs: SelectedMaterial) -> Bool {
        lhs.id == rhs.id
    }
}

public class CoursesViewModel: ObservableObject {

    @Published public var courses: [Course] = []
    @Published public var filteredCourses: [Course] = []
    @Published public var searchText: String = ""
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var showAddCourseSheet: Bool = false
    @Published public var courseToDelete: Course? = nil
    @Published public var showDeleteConfirmation: Bool = false

    @Published public var addCourseTab: AddCourseTab = .onlineCourse
    @Published public var courseURL: String = ""
    @Published public var courseName: String = ""
    @Published public var courseCode: String = ""
    @Published public var courseDescription: String = ""
    @Published public var courseStartDate: Date = Date()
    @Published public var courseDeadline: Date = Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()
    @Published public var selectedImageItem: PhotosPickerItem? = nil
    @Published public var selectedImageData: Data? = nil
    @Published public var selectedMaterials: [SelectedMaterial] = []
    @Published public var isCreatingCourse: Bool = false
    @Published public var createError: String?
    @Published public var showFileImporter: Bool = false
    @Published public var dailyStudyMinutes: Int = 30
    @Published public var preferredDays: String = "Mon,Tue,Wed,Thu,Fri"

    public enum AddCourseTab {
        case onlineCourse
        case uploadMaterial
    }

    private let fetchCoursesUseCase: FetchCoursesUseCase
    private let addCourseUseCase: AddCourseUseCase
    private let deleteCourseUseCase: DeleteCourseUseCase

    private var cancellables = Set<AnyCancellable>()

    public var onCourseSelected: ((String, String, String) -> Void)?

    public var canAddCourse: Bool {
        switch addCourseTab {
        case .onlineCourse:
            return !courseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && !courseURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .uploadMaterial:
            return !courseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && !selectedMaterials.isEmpty
        }
    }

    public var courseInitials: String {
        let words = courseName.split(separator: " ")
        let initials = words.prefix(2).compactMap { $0.first.map(String.init) }
        return initials.joined().uppercased()
    }

    public init(
        fetchCoursesUseCase: FetchCoursesUseCase,
        addCourseUseCase: AddCourseUseCase,
        deleteCourseUseCase: DeleteCourseUseCase
    ) {
        self.fetchCoursesUseCase = fetchCoursesUseCase
        self.addCourseUseCase = addCourseUseCase
        self.deleteCourseUseCase = deleteCourseUseCase

        setupSearchSubscription()
        setupImageSelectionSubscription()
    }

    public func selectCourse(course: Course) {
        onCourseSelected?(course.id, course.name, course.courseType.rawValue)
    }

    @MainActor
    public func loadCourses() async {
        isLoading = true
        errorMessage = nil

        do {
            courses = try await fetchCoursesUseCase.execute()
            applySearch()
        } catch {
            let errorText = error.localizedDescription.lowercased()
            if errorText.contains("cancelled") || errorText.contains("canceled") {
                return
            }
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    public func requestDelete(course: Course) {
        courseToDelete = course
        showDeleteConfirmation = true
    }

    @MainActor
    public func confirmDelete() {
        guard let course = courseToDelete else { return }
        courseToDelete = nil
        showDeleteConfirmation = false

        Task {
            do {
                try await deleteCourseUseCase.execute(id: course.id)
                await loadCourses()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    public func cancelDelete() {
        courseToDelete = nil
        showDeleteConfirmation = false
    }

    @MainActor
    public func addCourse() async {
        guard canAddCourse else { return }

        isCreatingCourse = true
        createError = nil

        do {
            let courseType: CourseType = addCourseTab == .onlineCourse ? .urlCourse : .materialCourse

            let materialInfos = selectedMaterials.map { material in
                MaterialFileInfo(
                    fileName: material.fileName,
                    contentType: material.contentType,
                    fileSizeBytes: material.fileSizeBytes,
                    fileData: material.fileData
                )
            }

            let _ = try await addCourseUseCase.execute(
                name: courseName,
                courseCode: courseCode,
                description: courseDescription.isEmpty ? nil : courseDescription,
                imageData: selectedImageData,
                startDate: courseStartDate,
                endDate: nil,
                examDate: courseDeadline,
                courseType: courseType,
                materialUrl: addCourseTab == .onlineCourse ? courseURL : nil,
                materials: addCourseTab == .uploadMaterial ? materialInfos : [],
                dailyStudyMinutes: dailyStudyMinutes,
                preferredDays: preferredDays
            )

            resetAddCourseForm()
            showAddCourseSheet = false
            await loadCourses()

        } catch {
            createError = error.localizedDescription
        }

        isCreatingCourse = false
    }

    public func removeMaterial(at index: Int) {
        guard index < selectedMaterials.count else { return }
        selectedMaterials.remove(at: index)
    }

    public func addMaterialFromURL(_ url: URL) {
        guard url.startAccessingSecurityScopedResource() else { return }
        defer { url.stopAccessingSecurityScopedResource() }

        do {
            let fileData = try Data(contentsOf: url)
            let fileName = url.lastPathComponent
            let contentType = contentType(for: url)
            let fileSizeBytes = fileData.count

            let material = SelectedMaterial(
                fileName: fileName,
                fileData: fileData,
                contentType: contentType,
                fileSizeBytes: fileSizeBytes
            )

            DispatchQueue.main.async {
                self.selectedMaterials.append(material)
            }
        } catch {
            print("Failed to read file: \(error)")
        }
    }

    public func resetAddCourseForm() {
        addCourseTab = .onlineCourse
        courseURL = ""
        courseName = ""
        courseCode = ""
        courseDescription = ""
        courseStartDate = Date()
        courseDeadline = Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()
        selectedImageItem = nil
        selectedImageData = nil
        selectedMaterials = []
        createError = nil
        dailyStudyMinutes = 30
        preferredDays = "Mon,Tue,Wed,Thu,Fri"
    }

    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.applySearch()
            }
            .store(in: &cancellables)
    }

    private func setupImageSelectionSubscription() {
        $selectedImageItem
            .sink { [weak self] item in
                guard let self = self else { return }
                guard let item = item else {
                    self.selectedImageData = nil
                    return
                }

                Task { [weak self] in
                    guard let self = self else { return }
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        DispatchQueue.main.async {
                            self.selectedImageData = data
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func applySearch() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if query.isEmpty {
            filteredCourses = courses
        } else {
            filteredCourses = courses.filter {
                $0.name.lowercased().contains(query) ||
                $0.courseCode.lowercased().contains(query)
            }
        }
    }

    private func contentType(for url: URL) -> String {
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "pdf": return "application/pdf"
        case "doc": return "application/msword"
        case "docx": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "ppt": return "application/vnd.ms-powerpoint"
        case "pptx": return "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        case "xls": return "application/vnd.ms-excel"
        case "xlsx": return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case "png": return "image/png"
        case "jpg", "jpeg": return "image/jpeg"
        case "txt": return "text/plain"
        default: return "application/octet-stream"
        }
    }
}

