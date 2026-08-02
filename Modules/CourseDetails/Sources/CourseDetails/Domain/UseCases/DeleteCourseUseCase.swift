//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation

public struct DeleteCourseUseCase {
    private let repository: CourseDetailsRepository
    
    public init(repository: CourseDetailsRepository) {
        self.repository = repository
    }
    
    public func execute(courseId: String) async throws {
        try await repository.deleteCourse(courseId: courseId)
    }
}
