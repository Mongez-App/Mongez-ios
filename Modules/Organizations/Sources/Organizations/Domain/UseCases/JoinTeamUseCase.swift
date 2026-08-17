import Foundation

public protocol JoinTeamUseCaseProtocol {
    func execute(inviteCode: String) async throws -> JoinTeamResponse
}

public class JoinTeamUseCase: JoinTeamUseCaseProtocol {
    private let organizationRepository: OrganizationRepositoryProtocol
    
    public init(organizationRepository: OrganizationRepositoryProtocol) {
        self.organizationRepository = organizationRepository
    }
    
    public func execute(inviteCode: String) async throws -> JoinTeamResponse {
        return try await organizationRepository.joinTeam(inviteCode: inviteCode)
    }
}
