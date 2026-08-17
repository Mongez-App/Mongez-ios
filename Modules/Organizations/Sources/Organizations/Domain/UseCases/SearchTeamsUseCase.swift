import Foundation

public protocol SearchTeamsUseCaseProtocol {
    func execute(query: String) async throws -> SearchResponse
}

public class SearchTeamsUseCase: SearchTeamsUseCaseProtocol {
    private let organizationRepository: OrganizationRepositoryProtocol
    
    public init(organizationRepository: OrganizationRepositoryProtocol) {
        self.organizationRepository = organizationRepository
    }
    
    public func execute(query: String) async throws -> SearchResponse {
        return try await organizationRepository.searchTeams(query: query)
    }
}
