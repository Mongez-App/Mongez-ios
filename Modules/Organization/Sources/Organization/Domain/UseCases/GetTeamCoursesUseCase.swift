//
//  GetTeamCoursesUseCase.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation

public protocol GetTeamCoursesUseCaseProtocol {
    func execute(teamId: String) async throws -> [TeamCourse]
}

public class GetTeamCoursesUseCase: GetTeamCoursesUseCaseProtocol {
    var organizationRepository: OrganizationRepositoryProtocol

    public init(organizationRepository: OrganizationRepositoryProtocol) {
        self.organizationRepository = organizationRepository
    }

    public func execute(teamId: String) async throws -> [TeamCourse] {
        return try await organizationRepository.getTeamCourses(teamId: teamId)
    }
}
