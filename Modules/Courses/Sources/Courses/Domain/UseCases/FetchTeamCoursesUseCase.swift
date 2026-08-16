import Foundation

public class FetchTeamCoursesUseCase {
    private let repository: TeamCoursesRepositoryProtocol
    
    public init(repository: TeamCoursesRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(teamId: String, organizationId: String) async throws -> [TeamCourse] {
        return try await repository.fetchTeamCourses(teamId: teamId, organizationId: organizationId)
    }
}
