import Foundation

public protocol CoursesRepositoryProtocol {
    func fetchCourses() async throws -> [Course]
    func createCourse(name: String, courseCode: String, imageUrl: String?, startDate: Date, endDate: Date?, examDate: Date, courseType: CourseType, materialUrl: String?) async throws -> Course
    func createMaterialCourse(name: String, courseCode: String, imageUrl: String?, startDate: Date, examDate: Date) async throws -> Course
    func updateCourse(id: String, name: String?, imageUrl: String?, isHidden: Bool?) async throws -> Course
    func deleteCourse(id: String) async throws
    func createMaterial(courseId: String, fileName: String, contentType: String, fileSizeBytes: Int, pageCount: Int?, deviceFileUri: String) async throws -> Material
    func uploadMaterialPDF(materialId: String, fileData: Data, fileName: String, contentType: String) async throws -> Material
    func listMaterials(courseId: String) async throws -> [Material]
    func deleteMaterial(courseId: String, materialId: String) async throws
}
