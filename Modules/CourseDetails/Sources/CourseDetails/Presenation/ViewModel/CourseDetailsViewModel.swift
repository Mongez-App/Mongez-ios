import Foundation
import Combine

@MainActor
public class CourseDetailsViewModel: ObservableObject {
    @Published public var selectedTab: Int = 0
    @Published public var materials: [CourseMaterial] = []
    @Published public var tasks: [CourseTask] = []
    @Published public var isUploading = false
    @Published public var showFileImporter = false
    @Published public var uploadError: String?
    @Published public var uploadSuccess = false
    
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
    private let repository: CourseDetailsRepository
    
    public init(courseId: String, getMaterialsUseCase: GetCourseMaterialsUseCase, getTasksUseCase: GetCourseTasksUseCase, repository: CourseDetailsRepository) {
        self.courseId = courseId
        self.getMaterialsUseCase = getMaterialsUseCase
        self.getTasksUseCase = getTasksUseCase
        self.repository = repository
    }
    
    public func loadData() async {
        do {
            materials = try await getMaterialsUseCase.execute(courseId: courseId)
            tasks = try await getTasksUseCase.execute(courseId: courseId)
        } catch is CancellationError {
            return
        } catch {
            print("Error loading course details: \(error)")
        }
    }
    
    public func uploadMaterial(from url: URL) {
        guard !isUploading else { return }
        isUploading = true
        uploadError = nil
        uploadSuccess = false
        
        Task {
            do {
                let fileData = try Data(contentsOf: url)
                let fileName = url.lastPathComponent
                let contentType = Self.contentType(for: url.pathExtension)
                
                try await repository.uploadMaterial(
                    courseId: courseId,
                    fileData: fileData,
                    fileName: fileName,
                    contentType: contentType,
                    pageCount: nil
                )

                try? await waitForDocuments(maxRetries: 15, delaySec: 2)
                try? await repository.generateTasks(courseId: courseId)

                uploadSuccess = true
                materials = try await getMaterialsUseCase.execute(courseId: courseId)
                tasks = try await getTasksUseCase.execute(courseId: courseId)
            } catch {
                print("Upload error: \(error)")
                uploadError = error.localizedDescription
            }
            isUploading = false
        }
    }
    
    private func waitForDocuments(maxRetries: Int, delaySec: UInt64) async throws {
        for _ in 0..<maxRetries {
            let docs = try? await getMaterialsUseCase.execute(courseId: courseId)
            if let docs = docs, !docs.isEmpty {
                return
            }
            try await Task.sleep(nanoseconds: delaySec * 1_000_000_000)
        }
    }

    public func selectTask(_ task: CourseTask) {
        if !task.isCompleted {
            onTaskSelected?(courseId, task.title)
        }
    }
    
    private static func contentType(for ext: String) -> String {
        switch ext.lowercased() {
        case "pdf": return "application/pdf"
        case "ppt", "pptx": return "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        case "doc", "docx": return "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        case "xls", "xlsx": return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        case "txt": return "text/plain"
        default: return "application/octet-stream"
        }
    }
}
