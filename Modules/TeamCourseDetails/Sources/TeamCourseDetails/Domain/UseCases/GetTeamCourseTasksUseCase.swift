//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
public struct GetTeamCourseTasksUseCase {
    private let repository: TeamCourseDetailsRepository
    
    public init(repository: TeamCourseDetailsRepository) {
        self.repository = repository
    }
    
    public func execute(courseId: String) async throws -> [TeamCourseTask] {
        return try await repository.getTasks(courseId: courseId)
    }
}
