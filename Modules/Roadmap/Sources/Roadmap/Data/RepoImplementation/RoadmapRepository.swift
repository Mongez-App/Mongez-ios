import Foundation

public class RoadmapRepository: RoadmapRepositoryProtocol {
    private let remoteDataSource: RoadmapRemoteDataSourceProtocol

    public init(remoteDataSource: RoadmapRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    public func getRoadmap() async throws -> Roadmap {
        let roadmapDTO = try await remoteDataSource.getRoadmap()
        return RoadmapDTO.mapToEntity(roadmapDTO)
    }

    public func getCourses() async throws -> [Course] {
        let dtos = try await remoteDataSource.getCourses()
        return dtos.map { $0.toDomain() }
    }

    public func addEvent(courseId: String, eventType: String, title: String, dueDate: String, weight: Int) async throws {
        try await remoteDataSource.createEvent(courseId: courseId, eventType: eventType, title: title, dueDate: dueDate, weight: weight)
    }
}
