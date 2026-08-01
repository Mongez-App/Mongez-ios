import Foundation

public class AddMaterialUseCase {
    private let repository: CoursesRepositoryProtocol

    public init(repository: CoursesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(courseId: String, fileData: Data, fileName: String, contentType: String, dailyStudyMinutes: Int, preferredDays: String) async throws -> Material {
        return try await repository.addMaterial(
            courseId: courseId,
            fileData: fileData,
            fileName: fileName,
            contentType: contentType,
            dailyStudyMinutes: dailyStudyMinutes,
            preferredDays: preferredDays
        )
    }
}
