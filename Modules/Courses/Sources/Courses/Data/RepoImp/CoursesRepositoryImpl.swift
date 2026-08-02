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

    func createCourse(name: String, courseCode: String, imageUrl: String?, startDate: Date, endDate: Date?, examDate: Date, courseType: CourseType, materialUrl: String?) async throws -> Course {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime]

        let requestDTO = CreateCourseRequestDTO(
            name: name,
            courseCode: courseCode.isEmpty ? nil : courseCode,
            imageUrl: imageUrl,
            startDate: dateFormatter.string(from: startDate),
            examDate: dateFormatter.string(from: examDate),
            courseType: courseType.rawValue,
            materialUrl: materialUrl
        )

        let courseDTO = try await remoteDataSource.createCourse(requestDTO: requestDTO)
        return courseDTO.toDomain()
    }

    func updateCourse(id: String, name: String?, imageUrl: String?, isHidden: Bool?) async throws -> Course {
        let requestDTO = UpdateCourseRequestDTO(
            name: name,
            imageUrl: imageUrl,
            isHidden: isHidden
        )
        let courseDTO = try await remoteDataSource.updateCourse(id: id, requestDTO: requestDTO)
        return courseDTO.toDomain()
    }

    func deleteCourse(id: String) async throws {
        try await remoteDataSource.deleteCourse(id: id)
    }

    func addMaterial(courseId: String, fileData: Data, fileName: String, contentType: String, dailyStudyMinutes: Int, preferredDays: String) async throws -> Material {
        let materialDTO = try await remoteDataSource.addMaterial(
            courseId: courseId,
            fileData: fileData,
            fileName: fileName,
            contentType: contentType,
            dailyStudyMinutes: dailyStudyMinutes,
            preferredDays: preferredDays
        )
        return materialDTO.toDomain()
    }

    func listMaterials(courseId: String) async throws -> [Material] {
        let dtos = try await remoteDataSource.listMaterials(courseId: courseId)
        return dtos.map { $0.toDomain() }
    }

    func deleteMaterial(courseId: String, materialId: String) async throws {
        try await remoteDataSource.deleteMaterial(courseId: courseId, materialId: materialId)
    }
}
