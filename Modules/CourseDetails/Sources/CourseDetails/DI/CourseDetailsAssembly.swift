import Foundation
import Swinject
import Common

public class CourseDetailsAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(CourseDetailsRemoteDataSource.self) { _ in
            CourseDetailsRemoteDataSourceImpl()
        }
        
        container.register(CourseDetailsRepository.self) { resolver in
            let remoteDataSource = resolver.resolve(CourseDetailsRemoteDataSource.self)!
            return CourseDetailsRepositoryImpl(remoteDataSource: remoteDataSource)
        }
        
        container.register(GetCourseMaterialsUseCase.self) { resolver in
            let repository = resolver.resolve(CourseDetailsRepository.self)!
            return GetCourseMaterialsUseCase(repository: repository)
        }
        
        container.register(GetCourseTasksUseCase.self) { resolver in
            let repository = resolver.resolve(CourseDetailsRepository.self)!
            return GetCourseTasksUseCase(repository: repository)
        }
        
        container.register(UploadCourseMaterialUseCase.self) { resolver in
            let repository = resolver.resolve(CourseDetailsRepository.self)!
            return UploadCourseMaterialUseCase(repository: repository)
        }
        
        container.register(UpdateCourseUseCase.self) { resolver in
            let repository = resolver.resolve(CourseDetailsRepository.self)!
            return UpdateCourseUseCase(repository: repository)
        }
        
        container.register(DeleteCourseUseCase.self) { resolver in
            let repository = resolver.resolve(CourseDetailsRepository.self)!
            return DeleteCourseUseCase(repository: repository)
        }
        
        container.register(DeleteCourseMaterialUseCase.self) { resolver in
            let repository = resolver.resolve(CourseDetailsRepository.self)!
            return DeleteCourseMaterialUseCase(repository: repository)
        }
    }
}
