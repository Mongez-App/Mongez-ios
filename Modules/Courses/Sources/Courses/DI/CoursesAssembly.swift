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

        container.register(AddMaterialUseCase.self) { resolver in
            let repository = resolver.resolve(CoursesRepositoryProtocol.self)!
            let cloudinaryService = resolver.resolve(CloudinaryServiceProtocol.self)!
            return AddMaterialUseCase(repository: repository, cloudinaryService: cloudinaryService)
        }

        container.register(ListMaterialsUseCase.self) { resolver in
            let repository = resolver.resolve(CoursesRepositoryProtocol.self)!
            return ListMaterialsUseCase(repository: repository)
        }

        container.register(DeleteMaterialUseCase.self) { resolver in
            let repository = resolver.resolve(CoursesRepositoryProtocol.self)!
            return DeleteMaterialUseCase(repository: repository)
        }

        container.register(UpdateCourseUseCase.self) { resolver in
            let repository = resolver.resolve(CoursesRepositoryProtocol.self)!
            return UpdateCourseUseCase(repository: repository)
        }

        container.register(CoursesViewModel.self) { resolver in
            let fetchCoursesUseCase = resolver.resolve(FetchCoursesUseCase.self)!
            let addCourseUseCase = resolver.resolve(AddCourseUseCase.self)!
            let deleteCourseUseCase = resolver.resolve(DeleteCourseUseCase.self)!
            return CoursesViewModel(
                fetchCoursesUseCase: fetchCoursesUseCase,
                addCourseUseCase: addCourseUseCase,
                deleteCourseUseCase: deleteCourseUseCase
            )
        }.inObjectScope(.container)
        container.register(TeamCoursesRemoteDataSourceProtocol.self) { _ in
            TeamCoursesRemoteDataSource()
        }.inObjectScope(.container)

        container.register(TeamCoursesRepositoryProtocol.self) { resolver in
            let remoteDataSource = resolver.resolve(TeamCoursesRemoteDataSourceProtocol.self)!
            return TeamCoursesRepositoryImpl(remoteDataSource: remoteDataSource)
        }.inObjectScope(.container)

        container.register(FetchTeamCoursesUseCase.self) { resolver in
            let repository = resolver.resolve(TeamCoursesRepositoryProtocol.self)!
            return FetchTeamCoursesUseCase(repository: repository)
        }

        container.register(FetchTeamEventsUseCase.self) { resolver in
            let repository = resolver.resolve(TeamCoursesRepositoryProtocol.self)!
            return FetchTeamEventsUseCase(repository: repository)
        }

        container.register(TeamCoursesViewModel.self) { (resolver, teamId: String, teamName: String, organizationId: String) in
            let fetchCoursesUseCase = resolver.resolve(FetchTeamCoursesUseCase.self)!
            let fetchEventsUseCase = resolver.resolve(FetchTeamEventsUseCase.self)!
            return TeamCoursesViewModel(
                teamId: teamId,
                teamName: teamName,
                organizationId: organizationId,
                fetchTeamCoursesUseCase: fetchCoursesUseCase,
                fetchTeamEventsUseCase: fetchEventsUseCase
            )
        }
    }
}

