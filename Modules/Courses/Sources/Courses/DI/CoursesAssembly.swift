import Swinject
import Common

public final class CoursesAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {

        container.register(CloudinaryServiceProtocol.self) { _ in
            CloudinaryService()
        }.inObjectScope(.container)

        container.register(CoursesRemoteDataSourceProtocol.self) { _ in
            CoursesRemoteDataSource()
        }.inObjectScope(.container)

        container.register(CoursesRepositoryProtocol.self) { resolver in
            let remoteDataSource = resolver.resolve(CoursesRemoteDataSourceProtocol.self)!
            return CoursesRepositoryImpl(remoteDataSource: remoteDataSource)
        }.inObjectScope(.container)

        container.register(FetchCoursesUseCase.self) { resolver in
            let repository = resolver.resolve(CoursesRepositoryProtocol.self)!
            return FetchCoursesUseCase(repository: repository)
        }

        container.register(AddCourseUseCase.self) { resolver in
            let repository = resolver.resolve(CoursesRepositoryProtocol.self)!
            let cloudinaryService = resolver.resolve(CloudinaryServiceProtocol.self)!
            return AddCourseUseCase(repository: repository, cloudinaryService: cloudinaryService)
        }

        container.register(DeleteCourseUseCase.self) { resolver in
            let repository = resolver.resolve(CoursesRepositoryProtocol.self)!
            return DeleteCourseUseCase(repository: repository)
        }

        container.register(AddCourseFromURLUseCase.self) { resolver in
            let repository = resolver.resolve(CoursesRepositoryProtocol.self)!
            return AddCourseFromURLUseCase(repository: repository)
        }

        container.register(CoursesViewModel.self) { resolver in
            let fetchCoursesUseCase = resolver.resolve(FetchCoursesUseCase.self)!
            let addCourseUseCase = resolver.resolve(AddCourseUseCase.self)!
            let deleteCourseUseCase = resolver.resolve(DeleteCourseUseCase.self)!
            let addCourseFromURLUseCase = resolver.resolve(AddCourseFromURLUseCase.self)!
            return CoursesViewModel(
                fetchCoursesUseCase: fetchCoursesUseCase,
                addCourseUseCase: addCourseUseCase,
                deleteCourseUseCase: deleteCourseUseCase,
                addCourseFromURLUseCase: addCourseFromURLUseCase
            )
        }.inObjectScope(.container)
    }
}

