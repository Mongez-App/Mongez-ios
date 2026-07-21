import Foundation
import Combine
import SwiftUI
import PhotosUI

public class CoursesViewModel: ObservableObject {
    
    @Published public var courses: [Course] = []
    @Published public var searchText: String = ""
    @Published public var isLoading: Bool = false
    @Published public var showAddCourseSheet: Bool = false
    @Published public var courseToDelete: Course? = nil
    @Published public var showDeleteConfirmation: Bool = false
    
    
    @Published public var addCourseTab: AddCourseTab = .onlineCourse
    @Published public var courseURL: String = ""
    @Published public var courseName: String = ""
    @Published public var courseDeadline: Date = Date()
    @Published public var selectedImageItem: PhotosPickerItem? = nil
    @Published public var selectedImageData: Data? = nil
    
    public enum AddCourseTab {
        case onlineCourse
        case uploadMaterial
    }
    
    
    private let fetchCoursesUseCase: FetchCoursesUseCase
    private let addCourseUseCase: AddCourseUseCase
    private let deleteCourseUseCase: DeleteCourseUseCase
    private let searchCoursesUseCase: SearchCoursesUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() {
        let repository = CoursesRepositoryImpl()
        self.fetchCoursesUseCase = FetchCoursesUseCase(repository: repository)
        self.addCourseUseCase = AddCourseUseCase(repository: repository)
        self.deleteCourseUseCase = DeleteCourseUseCase(repository: repository)
        self.searchCoursesUseCase = SearchCoursesUseCase(repository: repository)
        
        setupSearchSubscription()
        setupImageSelectionSubscription()
        loadCourses()
    }
    
    
    public func loadCourses() {
        isLoading = true
        courses = fetchCoursesUseCase.execute()
        isLoading = false
    }
    
    public func requestDelete(course: Course) {
        courseToDelete = course
        showDeleteConfirmation = true
    }
    
    public func confirmDelete() {
        guard let course = courseToDelete else { return }
        deleteCourseUseCase.execute(id: course.id)
        courseToDelete = nil
        showDeleteConfirmation = false
        performSearch()
    }
    
    public func cancelDelete() {
        courseToDelete = nil
        showDeleteConfirmation = false
    }
    
    public func addCourse() {
        let newCourse: Course
        
        switch addCourseTab {
        case .onlineCourse:
            let name = courseURL
                .replacingOccurrences(of: "https://", with: "")
                .replacingOccurrences(of: "http://", with: "")
                .components(separatedBy: "/")
                .last ?? "Online Course"
            newCourse = Course(
                name: name.isEmpty ? "Online Course" : name.capitalized,
                courseCode: "OC_\(Int.random(in: 100...999))",
                startDate: Date(),
                examDate: courseDeadline,
                hasMaterials: false,
                completionPercentage: 0.0
            )
        case .uploadMaterial:
            newCourse = Course(
                name: courseName.isEmpty ? "New Course" : courseName,
                courseCode: "UM_\(Int.random(in: 100...999))",
                startDate: Date(),
                examDate: courseDeadline,
                hasMaterials: true,
                completionPercentage: 0.0,
                imageData: selectedImageData
            )
        }
        
        addCourseUseCase.execute(course: newCourse)
        resetAddCourseForm()
        showAddCourseSheet = false
        performSearch()
    }
    
    public func resetAddCourseForm() {
        addCourseTab = .onlineCourse
        courseURL = ""
        courseName = ""
        courseDeadline = Date()
        selectedImageItem = nil
        selectedImageData = nil
    }
    
    
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.performSearch()
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
    
    private func performSearch() {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            courses = fetchCoursesUseCase.execute()
        } else {
            courses = searchCoursesUseCase.execute(query: searchText)
        }
    }
}
