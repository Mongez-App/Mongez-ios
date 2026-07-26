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

        for material in materials {

            let materialResult = try await repository.addMaterialMetadata(
                courseId: course.id ?? "",
                fileName: material.fileName,
                contentType: material.contentType,
                fileSizeBytes: material.fileSizeBytes,
                pageCount: material.pageCount
            )

            if let uploadId = materialResult.uploadId ?? Optional(materialResult.id) {
                try await repository.uploadMaterialFile(
                    uploadId: uploadId,
                    fileData: material.fileData,
                    fileName: material.fileName,
                    contentType: material.contentType
                )
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

