//
//  GetMyCoursesUseCase.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation

public protocol GetMyCoursesUseCaseProtocol {
    func execute() async throws -> [TeamCourse]
}

public class GetMyCoursesUseCase: GetMyCoursesUseCaseProtocol {
    var organizationRepository: OrganizationRepositoryProtocol

    public init(organizationRepository: OrganizationRepositoryProtocol) {
        self.organizationRepository = organizationRepository
    }

    public func execute() async throws -> [TeamCourse] {
        return try await organizationRepository.getMyCourses()
    }
}
