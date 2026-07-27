import Foundation

public class DeleteCourseUseCase {
    private let repository: CoursesRepositoryProtocol

    public init(repository: CoursesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(id: String) async throws {
        try await repository.deleteCourse(id: id)
    }
}

