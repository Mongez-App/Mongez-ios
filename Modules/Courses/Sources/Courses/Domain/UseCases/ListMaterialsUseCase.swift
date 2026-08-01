import Foundation

public class ListMaterialsUseCase {
    private let repository: CoursesRepositoryProtocol

    public init(repository: CoursesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(courseId: String) async throws -> [Material] {
        return try await repository.listMaterials(courseId: courseId)
    }
}
