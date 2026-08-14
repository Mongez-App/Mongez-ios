import Foundation

public class AddMaterialUseCase {
    private let repository: CoursesRepositoryProtocol

    public init(repository: CoursesRepositoryProtocol) {
        self.repository = repository
    }

    /// Two-step material upload:
    /// 1. Create material metadata (JSON) to get material_id
    /// 2. Upload the actual PDF file using the material_id
    public func execute(
        courseId: String,
        fileData: Data,
        fileName: String,
        contentType: String,
        fileSizeBytes: Int,
        pageCount: Int?,
        deviceFileUri: String
    ) async throws -> Material {
        // Step 1: Create material metadata
        let createdMaterial = try await repository.createMaterial(
            courseId: courseId,
            fileName: fileName,
            contentType: contentType,
            fileSizeBytes: fileSizeBytes,
            pageCount: pageCount,
            deviceFileUri: deviceFileUri
        )

        // Step 2: Upload the actual PDF file
        let uploadedMaterial = try await repository.uploadMaterialPDF(
            materialId: createdMaterial.id,
            fileData: fileData,
            fileName: fileName,
            contentType: contentType
        )

        return uploadedMaterial
    }
}
