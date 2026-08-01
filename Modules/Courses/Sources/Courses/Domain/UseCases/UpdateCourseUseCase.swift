import Foundation

public class UpdateCourseUseCase {
    private let repository: CoursesRepositoryProtocol

    public init(repository: CoursesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(id: String, name: String? = nil, imageUrl: String? = nil, isHidden: Bool? = nil) async throws -> Course {
        return try await repository.updateCourse(id: id, name: name, imageUrl: imageUrl, isHidden: isHidden)
    }
}
