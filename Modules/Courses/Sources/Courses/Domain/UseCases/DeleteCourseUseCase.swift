import Foundation

public class DeleteCourseUseCase {
    private let repository: CoursesRepositoryProtocol
    
    public init(repository: CoursesRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(id: String) {
        repository.deleteCourse(id: id)
    }
}
