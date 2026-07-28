import Foundation

public class CourseDetailsRepositoryImpl: CourseDetailsRepository {
    private let remoteDataSource: CourseDetailsRemoteDataSourceProtocol

    public init(remoteDataSource: CourseDetailsRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    public func getMaterials(courseId: String) async throws -> [CourseMaterial] {
        let dtos = try await remoteDataSource.getMaterials(courseId: courseId)
        return dtos.map { $0.toDomain() }
    }

    public func getTasks(courseId: String) async throws -> [CourseTask] {
        let dtos = try await remoteDataSource.getTasks(courseId: courseId)
        return dtos.map { $0.toDomain(group: .today) }
    }

    public func uploadMaterial(courseId: String, fileData: Data, fileName: String, contentType: String, pageCount: Int?) async throws {
        _ = try await remoteDataSource.uploadDocument(
            courseId: courseId,
            fileData: fileData,
            fileName: fileName,
            contentType: contentType
        )
    }

    public func generateTasks(courseId: String) async throws {
        try await remoteDataSource.createTasks(courseId: courseId)
    }
}
