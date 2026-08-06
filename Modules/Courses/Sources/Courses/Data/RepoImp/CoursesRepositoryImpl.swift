import Foundation
import Common

final class CoursesRepositoryImpl: CoursesRepositoryProtocol {
    private let remoteDataSource: CoursesRemoteDataSourceProtocol

    init(remoteDataSource: CoursesRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchCourses() async throws -> [Course] {
        let dtos = try await remoteDataSource.fetchCourses()
        return dtos.map { $0.toDomain() }
    }

    func createCourse(name: String, courseCode: String, imageUrl: String?, startDate: Date, endDate: Date?, examDate: Date, hasMaterials: Bool) async throws -> Course {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let courseId = UUID().uuidString

        let requestDTO = CreateCourseRequestDTO(
            courseId: courseId,
            courseName: name,
            code: courseCode,
            startDate: dateFormatter.string(from: startDate),
            endDate: endDate.map { dateFormatter.string(from: $0) }
        )

        let courseDTO = try await remoteDataSource.createCourse(requestDTO: requestDTO)
        return courseDTO.toDomain()
    }

    func deleteCourse(id: String) async throws {
        try await remoteDataSource.deleteCourse(id: id)
    }

    func uploadMaterialFile(courseId: String, fileData: Data, fileName: String, contentType: String) async throws {
        try await remoteDataSource.uploadMaterialFile(courseId: courseId, fileData: fileData, fileName: fileName, contentType: contentType)
    }

    func listMaterials(courseId: String) async throws -> [Material] {
        let dtos = try await remoteDataSource.listMaterials(courseId: courseId)
        return dtos.map { $0.toDomain() }
    }

    func createTasks(courseId: String, quizQuestionsPerTask: Int) async throws {
        let requestDTO = CreateTasksRequestDTO(quizQuestionsPerTask: quizQuestionsPerTask)
        try await remoteDataSource.createTasks(courseId: courseId, requestDTO: requestDTO)
    }

    func listTasks(courseId: String) async throws -> [CourseTask] {
        let dtos = try await remoteDataSource.listTasks(courseId: courseId)
        return dtos.map { $0.toDomain() }
    }

    func createEvent(courseId: String, eventType: String, title: String, dueDate: String, weight: Int) async throws {
        let requestDTO = CreateEventRequestDTO(eventType: eventType, title: title, dueDate: dueDate, weight: weight)
        try await remoteDataSource.createEvent(courseId: courseId, requestDTO: requestDTO)
    }

    func listEvents(courseId: String) async throws -> [CourseEvent] {
        let dtos = try await remoteDataSource.listEvents(courseId: courseId)
        return dtos.map { $0.toDomain() }
    }

    func addCourseFromURL(url: String) async throws -> Course {
        let requestDTO = AddCourseFromURLRequestDTO(url: url)
        let courseDTO = try await remoteDataSource.addCourseFromURL(requestDTO: requestDTO)
        return courseDTO.toDomain()
    }
}
