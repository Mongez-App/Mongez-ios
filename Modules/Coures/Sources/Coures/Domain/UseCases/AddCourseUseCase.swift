import Foundation

public class AddCourseUseCase {
    private let repository: CoursesRepositoryProtocol
    
    public init(repository: CoursesRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(course: Course) {
        repository.addCourse(course)
    }
}
