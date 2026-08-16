import Foundation

public protocol DiscoverTeamsUseCaseProtocol {
    func execute() async throws -> OrgTeamsResponse
}

public class DiscoverTeamsUseCase: DiscoverTeamsUseCaseProtocol {
    private let organizationRepository: OrganizationRepositoryProtocol
    
    public init(organizationRepository: OrganizationRepositoryProtocol) {
        self.organizationRepository = organizationRepository
    }
    
    public func execute() async throws -> OrgTeamsResponse {
        return try await organizationRepository.discoverTeams()
    }
}
