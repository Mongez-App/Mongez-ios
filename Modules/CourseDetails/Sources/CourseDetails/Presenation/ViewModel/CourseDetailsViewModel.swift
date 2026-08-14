//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import Combine
import PDFKit

@MainActor
public class CourseDetailsViewModel: ObservableObject {
    @Published public var selectedTab: Int = 0
    @Published public var materials: [CourseMaterial] = []
    @Published public var tasks: [CourseTask] = []
    @Published public var courseName: String
    @Published public var courseType: String
    @Published public var showFileImporter: Bool = false
    @Published public var isUploading: Bool = false
    @Published public var isLoading: Bool = false
    
    public var onTaskSelected: ((String, String) -> Void)?
    public var completedTasksCount: Int { tasks.filter { $0.isCompleted }.count }
    public var totalTasksCount: Int { tasks.count }
    public var progressPercentage: Double {
        guard totalTasksCount > 0 else { return 0 }
        return Double(completedTasksCount) / Double(totalTasksCount)
    }
    
    private let courseId: String
    private let getMaterialsUseCase: GetCourseMaterialsUseCase
    private let getTasksUseCase: GetCourseTasksUseCase
    private let uploadMaterialUseCase: UploadCourseMaterialUseCase
    private let updateCourseUseCase: UpdateCourseUseCase
    private let deleteCourseUseCase: DeleteCourseUseCase
    private let deleteCourseMaterialUseCase: DeleteCourseMaterialUseCase
    
    nonisolated public init(
        courseId: String,
        courseName: String,
        courseType: String,
        getMaterialsUseCase: GetCourseMaterialsUseCase,
        getTasksUseCase: GetCourseTasksUseCase,
        uploadMaterialUseCase: UploadCourseMaterialUseCase,
        updateCourseUseCase: UpdateCourseUseCase,
        deleteCourseUseCase: DeleteCourseUseCase,
        deleteCourseMaterialUseCase: DeleteCourseMaterialUseCase
    ) {
        self.courseId = courseId
        self._courseName = Published(wrappedValue: courseName)
        self._courseType = Published(wrappedValue: courseType)
        self.getMaterialsUseCase = getMaterialsUseCase
        self.getTasksUseCase = getTasksUseCase
        self.uploadMaterialUseCase = uploadMaterialUseCase
        self.updateCourseUseCase = updateCourseUseCase
        self.deleteCourseUseCase = deleteCourseUseCase
        self.deleteCourseMaterialUseCase = deleteCourseMaterialUseCase
    }
    
    public func loadData() async {
        isLoading = true
        do {
            materials = try await getMaterialsUseCase.execute(courseId: courseId)
            tasks = try await getTasksUseCase.execute(courseId: courseId)
            isLoading = false
        } catch is CancellationError {
            isLoading = false
            return
        } catch {
            isLoading = false
            print("Error loading course details: \(error)")
        }
    }
    
    public func selectTask(_ task: CourseTask) {
        if !task.isCompleted {
            onTaskSelected?(task.id, task.title)
        }
    }
    
    public func uploadMaterial(fileURL: URL) async {
            guard fileURL.startAccessingSecurityScopedResource() else { return }
            defer { fileURL.stopAccessingSecurityScopedResource() }
            
            do {
                isUploading = true
                
                let fileData = try Data(contentsOf: fileURL)
                let fileName = fileURL.lastPathComponent
                let resources = try fileURL.resourceValues(forKeys: [.fileSizeKey])
                let sizeBytes = resources.fileSize ?? fileData.count
                var pageCount = 0
                if let pdfDocument = PDFDocument(data: fileData) {
                    pageCount = pdfDocument.pageCount
                }
                _ = try await uploadMaterialUseCase.execute(
                    courseId: courseId,
                    fileData: fileData,
                    fileName: fileName,
                    sizeBytes: sizeBytes,
                    pageCount: pageCount
                )
                
                await loadData()
                isUploading = false
            } catch {
                print("Error uploading material: \(error)")
                isUploading = false
            }
        }
    
    public func updateCourse(name: String) async {
        do {
            let updatedCourse = try await updateCourseUseCase.execute(courseId: courseId, name: name, imageUrl: nil, isHidden: nil)
            self.courseName = updatedCourse.name
        } catch {
            print("Error updating course: \(error)")
        }
    }
    
    public func deleteCourse() async {
        do {
            try await deleteCourseUseCase.execute(courseId: courseId)
        } catch {
            print("Error deleting course: \(error)")
        }
    }
    
    public func deleteMaterial(materialId: String) async {
        do {
            try await deleteCourseMaterialUseCase.execute(courseId: courseId, materialId: materialId)
            self.materials.removeAll { $0.id == materialId }
            tasks = try await getTasksUseCase.execute(courseId: courseId)
        } catch {
            print("Error deleting material: \(error)")
        }
    }
}
