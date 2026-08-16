import Foundation
import Swinject
import Common

public class OrganizationsAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        
        container.register(OrganizationRemoteDataSourceProtocol.self) { _ in
            OrganizationRemoteDataSource()
        }
        
        container.register(OrganizationRepositoryProtocol.self) { resolver in
            OrganizationRepository(remoteDataSource: resolver.resolve(OrganizationRemoteDataSourceProtocol.self)!)
        }
        
        container.register(GetUserTeamsUseCaseProtocol.self) { resolver in
            GetUserTeamsUseCase(organizationRepository: resolver.resolve(OrganizationRepositoryProtocol.self)!)
        }
        
        container.register(DiscoverTeamsUseCaseProtocol.self) { resolver in
            DiscoverTeamsUseCase(organizationRepository: resolver.resolve(OrganizationRepositoryProtocol.self)!)
        }
        
        container.register(JoinTeamUseCaseProtocol.self) { resolver in
            JoinTeamUseCase(organizationRepository: resolver.resolve(OrganizationRepositoryProtocol.self)!)
        }
        
        container.register(SearchTeamsUseCaseProtocol.self) { resolver in
            SearchTeamsUseCase(organizationRepository: resolver.resolve(OrganizationRepositoryProtocol.self)!)
        }
        
        container.register(OrganizationsViewModel.self) { resolver in
            OrganizationsViewModel(getUserTeamsUseCase: resolver.resolve(GetUserTeamsUseCaseProtocol.self)!)
        }
    }
}
