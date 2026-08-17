import Foundation
import Swinject
import Common

public class TeamCourseDetailsAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(TeamCourseDetailsRemoteDataSource.self) { _ in
            TeamCourseDetailsRemoteDataSourceImpl()
        }
        
        container.register(CloudinaryServiceProtocol.self) { _ in
            CloudinaryService()
        }.inObjectScope(.container)
        
        container.register(TeamCourseDetailsRepository.self) { resolver in
            let remoteDataSource = resolver.resolve(TeamCourseDetailsRemoteDataSource.self)!
            return TeamCourseDetailsRepositoryImpl(remoteDataSource: remoteDataSource)
        }
        
        container.register(GetTeamCourseMaterialsUseCase.self) { resolver in
            let repository = resolver.resolve(TeamCourseDetailsRepository.self)!
            return GetTeamCourseMaterialsUseCase(repository: repository)
        }
        
        container.register(GetTeamCourseTasksUseCase.self) { resolver in
            let repository = resolver.resolve(TeamCourseDetailsRepository.self)!
            return GetTeamCourseTasksUseCase(repository: repository)
        }
    }
}
