import Foundation

public class FetchTeamEventsUseCase {
    private let repository: TeamCoursesRepositoryProtocol
    
    public init(repository: TeamCoursesRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(teamId: String, organizationId: String) async throws -> [TeamEvent] {
        return try await repository.fetchTeamEvents(teamId: teamId, organizationId: organizationId)
    }
}
