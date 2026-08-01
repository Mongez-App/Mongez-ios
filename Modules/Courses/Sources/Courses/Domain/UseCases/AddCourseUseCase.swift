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
        courseType: CourseType,
        materialUrl: String?,
        materials: [MaterialFileInfo],
        dailyStudyMinutes: Int,
        preferredDays: String
    ) async throws -> Course {

        var imageUrl: String? = nil
        if let imageData = imageData {
            imageUrl = try await cloudinaryService.uploadImage(imageData: imageData)
        }

        let course = try await repository.createCourse(
            name: name,
            courseCode: courseCode,
            imageUrl: imageUrl,
            startDate: startDate,
            endDate: endDate,
            examDate: examDate,
            courseType: courseType,
            materialUrl: materialUrl
        )

        if courseType == .materialCourse {
            try await withThrowingTaskGroup(of: Void.self) { group in
                for material in materials {
                    group.addTask {
                        let _ = try await self.repository.addMaterial(
                            courseId: course.id,
                            fileData: material.fileData,
                            fileName: material.fileName,
                            contentType: material.contentType,
                            dailyStudyMinutes: dailyStudyMinutes,
                            preferredDays: preferredDays
                        )
                    }
                }
                try await group.waitForAll()
            }
        }

        return course
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
