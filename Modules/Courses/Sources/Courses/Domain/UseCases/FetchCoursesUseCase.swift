import Foundation

public class FetchCoursesUseCase {
    private let repository: CoursesRepositoryProtocol

    public init(repository: CoursesRepositoryProtocol) {
        self.repository = repository
    }

    public func execute() async throws -> [Course] {
        return try await repository.fetchCourses()
    }
}

