//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
public struct GetCourseTasksUseCase {
    private let repository: CourseDetailsRepository
    
    public init(repository: CourseDetailsRepository) {
        self.repository = repository
    }
    
    public func execute(courseId: String) async throws -> [CourseTask] {
        return try await repository.getTasks(courseId: courseId)
    }
}
