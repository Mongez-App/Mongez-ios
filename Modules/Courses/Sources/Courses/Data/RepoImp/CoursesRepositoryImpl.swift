import Foundation

class CoursesRepositoryImpl: CoursesRepositoryProtocol {
    private let dataSource: InMemoryCourseDataSource
    
    init(dataSource: InMemoryCourseDataSource = .shared) {
        self.dataSource = dataSource
    }
    
    func fetchCourses() -> [Course] {
        return dataSource.getAll()
    }
    
    func addCourse(_ course: Course) {
        dataSource.add(course)
    }
    
    func deleteCourse(id: String) {
        dataSource.delete(id: id)
    }
    
    func searchCourses(query: String) -> [Course] {
        return dataSource.search(query: query)
    }
}
