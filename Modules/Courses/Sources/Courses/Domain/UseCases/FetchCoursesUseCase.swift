import Foundation

public class FetchCoursesUseCase {
    private let repository: CoursesRepositoryProtocol
    
    public init(repository: CoursesRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute() -> [Course] {
        return repository.fetchCourses()
    }
}
