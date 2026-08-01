import Foundation

public class DeleteMaterialUseCase {
    private let repository: CoursesRepositoryProtocol

    public init(repository: CoursesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(courseId: String, materialId: String) async throws {
        try await repository.deleteMaterial(courseId: courseId, materialId: materialId)
    }
}
