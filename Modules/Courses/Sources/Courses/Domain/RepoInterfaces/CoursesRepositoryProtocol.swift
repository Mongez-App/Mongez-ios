import Foundation

public protocol CoursesRepositoryProtocol {
    func fetchCourses() async throws -> [Course]
    func createCourse(name: String, courseCode: String, imageUrl: String?, startDate: Date, endDate: Date?, examDate: Date, hasMaterials: Bool) async throws -> Course
    func deleteCourse(id: String) async throws
    func addMaterialMetadata(courseId: String, fileName: String, contentType: String, fileSizeBytes: Int, pageCount: Int?) async throws -> Material
    func uploadMaterialFile(uploadId: String, fileData: Data, fileName: String, contentType: String) async throws
    func addCourseFromURL(url: String) async throws -> Course
}

