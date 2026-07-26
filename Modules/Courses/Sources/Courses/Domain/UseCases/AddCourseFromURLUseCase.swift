import Foundation

public class AddCourseFromURLUseCase {
    private let repository: CoursesRepositoryProtocol

    public init(repository: CoursesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(url: String) async throws -> Course {
        return try await repository.addCourseFromURL(url: url)
    }
}

