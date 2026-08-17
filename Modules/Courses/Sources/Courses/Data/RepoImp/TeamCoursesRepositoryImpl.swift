import Foundation

final class TeamCoursesRepositoryImpl: TeamCoursesRepositoryProtocol {
    private let remoteDataSource: TeamCoursesRemoteDataSourceProtocol
    
    init(remoteDataSource: TeamCoursesRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchTeamCourses(teamId: String, organizationId: String) async throws -> [TeamCourse] {
        let dtos = try await remoteDataSource.fetchTeamCourses(teamId: teamId, organizationId: organizationId)
        return dtos.map { $0.toDomain() }
    }
    
    func fetchTeamEvents(teamId: String, organizationId: String) async throws -> [TeamEvent] {
        let dtos = try await remoteDataSource.fetchTeamEvents(teamId: teamId, organizationId: organizationId)
        return dtos.map { $0.toDomain() }
    }
}
