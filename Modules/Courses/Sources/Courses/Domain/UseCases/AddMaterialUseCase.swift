import Foundation
import Common

public class AddMaterialUseCase {
    private let repository: CoursesRepositoryProtocol
    private let cloudinaryService: CloudinaryServiceProtocol

    public init(repository: CoursesRepositoryProtocol, cloudinaryService: CloudinaryServiceProtocol) {
        self.repository = repository
        self.cloudinaryService = cloudinaryService
    }

    /// Upload material to Cloudinary and create metadata
    public func execute(
        courseId: String,
        fileData: Data,
        fileName: String,
        contentType: String,
        fileSizeBytes: Int,
        pageCount: Int?
    ) async throws -> Material {
        // Step 1: Upload to Cloudinary
        let cloudinaryUrl = try await cloudinaryService.uploadPDF(fileData: fileData, fileName: fileName)

        // Step 2: Create material metadata
        let createdMaterial = try await repository.createMaterial(
            courseId: courseId,
            fileName: fileName,
            contentType: contentType,
            fileSizeBytes: fileSizeBytes,
            pageCount: pageCount,
            deviceFileUri: cloudinaryUrl
        )

        return createdMaterial
    }
}
