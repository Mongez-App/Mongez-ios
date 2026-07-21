import Foundation

public class SearchCoursesUseCase {
    private let repository: CoursesRepositoryProtocol
    
    public init(repository: CoursesRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(query: String) -> [Course] {
        return repository.searchCourses(query: query)
    }
}
