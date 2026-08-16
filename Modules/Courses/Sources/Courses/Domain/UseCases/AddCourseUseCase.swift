import Foundation
import Common

public class AddCourseUseCase {
    private let repository: CoursesRepositoryProtocol
    private let cloudinaryService: CloudinaryServiceProtocol

    public init(repository: CoursesRepositoryProtocol, cloudinaryService: CloudinaryServiceProtocol) {
        self.repository = repository
        self.cloudinaryService = cloudinaryService
    }

    // Online Course tab (old format with course_type + material_url)
    public func executeOnlineCourse(
        name: String,
        courseCode: String,
        description: String?,
        imageData: Data?,
        startDate: Date,
        endDate: Date?,
        examDate: Date,
        materialUrl: String?
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
            courseType: .urlCourse,
            materialUrl: materialUrl
        )

        return course
    }

    // Upload Material tab (new format with has_materials + two-step material upload)
    public func executeMaterialCourse(
        name: String,
        courseCode: String,
        description: String?,
        imageData: Data?,
        startDate: Date,
        examDate: Date,
        materials: [MaterialFileInfo]
    ) async throws -> Course {

        var imageUrl: String? = nil
        if let imageData = imageData {
            imageUrl = try await cloudinaryService.uploadImage(imageData: imageData)
        }

        let course = try await repository.createMaterialCourse(
            name: name,
            courseCode: courseCode,
            imageUrl: imageUrl,
            startDate: startDate,
            examDate: examDate
        )

        // Upload each material to Cloudinary and create in backend
        for material in materials {
            let cloudinaryUrl = try await cloudinaryService.uploadPDF(fileData: material.fileData, fileName: material.fileName)
            
            let createdMaterial = try await repository.createMaterial(
                courseId: course.id,
                fileName: material.fileName,
                contentType: material.contentType,
                fileSizeBytes: material.fileSizeBytes,
                pageCount: material.pageCount,
                deviceFileUri: cloudinaryUrl
            )
            
            let _ = try await repository.uploadMaterialPDF(
                materialId: createdMaterial.id,
                fileData: material.fileData,
                fileName: material.fileName,
                contentType: material.contentType
            )
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
    public let deviceFileUri: String

    public init(fileName: String, contentType: String, fileSizeBytes: Int, pageCount: Int? = nil, fileData: Data, deviceFileUri: String) {
        self.fileName = fileName
        self.contentType = contentType
        self.fileSizeBytes = fileSizeBytes
        self.pageCount = pageCount
        self.fileData = fileData
        self.deviceFileUri = deviceFileUri
    }
}
