import Foundation

public class AddCourseUseCase {
    private let repository: CoursesRepositoryProtocol
    private let cloudinaryService: CloudinaryServiceProtocol

    public init(repository: CoursesRepositoryProtocol, cloudinaryService: CloudinaryServiceProtocol) {
        self.repository = repository
        self.cloudinaryService = cloudinaryService
    }

    public func execute(
        name: String,
        courseCode: String,
        description: String?,
        imageData: Data?,
        startDate: Date,
        endDate: Date?,
        examDate: Date,
        materials: [MaterialFileInfo]
    ) async throws -> Course {

        var imageUrl: String? = nil
        if let imageData = imageData {
            imageUrl = try await cloudinaryService.uploadImage(imageData: imageData)
        }

        let hasMaterials = !materials.isEmpty
        let course = try await repository.createCourse(
            name: name,
            courseCode: courseCode,
            imageUrl: imageUrl,
            startDate: startDate,
            endDate: endDate,
            examDate: examDate,
            hasMaterials: hasMaterials
        )

        let courseId = course.id ?? ""

        try await withThrowingTaskGroup(of: Void.self) { group in
            for material in materials {
                group.addTask {
                    try await self.repository.uploadMaterialFile(
                        courseId: courseId,
                        fileData: material.fileData,
                        fileName: material.fileName,
                        contentType: material.contentType
                    )
                }
            }
            try await group.waitForAll()
        }

        if !materials.isEmpty {
            try? await waitForDocuments(courseId: courseId, maxRetries: 15, delaySec: 2)
            try? await repository.createTasks(courseId: courseId, quizQuestionsPerTask: 7)
        }

        return course
    }

    private func waitForDocuments(courseId: String, maxRetries: Int, delaySec: UInt64) async throws {
        for _ in 0..<maxRetries {
            let docs = try? await repository.listMaterials(courseId: courseId)
            if let docs = docs, !docs.isEmpty {
                return
            }
            try await Task.sleep(nanoseconds: delaySec * 1_000_000_000)
        }
    }
}

public struct MaterialFileInfo {
    public let fileName: String
    public let contentType: String
    public let fileSizeBytes: Int
    public let pageCount: Int?
    public let fileData: Data

    public init(fileName: String, contentType: String, fileSizeBytes: Int, pageCount: Int? = nil, fileData: Data) {
        self.fileName = fileName
        self.contentType = contentType
        self.fileSizeBytes = fileSizeBytes
        self.pageCount = pageCount
        self.fileData = fileData
    }
}
