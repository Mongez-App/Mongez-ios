import Foundation

public protocol CoursesRepositoryProtocol {
    func fetchCourses() async throws -> [Course]
    func createCourse(name: String, courseCode: String, imageUrl: String?, startDate: Date, endDate: Date?, examDate: Date, hasMaterials: Bool) async throws -> Course
    func deleteCourse(id: String) async throws
    func uploadMaterialFile(courseId: String, fileData: Data, fileName: String, contentType: String) async throws
    func listMaterials(courseId: String) async throws -> [Material]
    func createTasks(courseId: String, quizQuestionsPerTask: Int) async throws
    func listTasks(courseId: String) async throws -> [CourseTask]
    func createEvent(courseId: String, eventType: String, title: String, dueDate: String, weight: Int) async throws
    func listEvents(courseId: String) async throws -> [CourseEvent]
    func addCourseFromURL(url: String) async throws -> Course
}
