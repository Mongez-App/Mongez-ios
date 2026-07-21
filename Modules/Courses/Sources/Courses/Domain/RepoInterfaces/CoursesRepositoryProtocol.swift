import Foundation

public protocol CoursesRepositoryProtocol {
    func fetchCourses() -> [Course]
    func addCourse(_ course: Course)
    func deleteCourse(id: String)
    func searchCourses(query: String) -> [Course]
}
