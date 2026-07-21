//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
public struct GetCourseMaterialsUseCase {
    private let repository: CourseDetailsRepository
    
    public init(repository: CourseDetailsRepository) {
        self.repository = repository
    }
    
    public func execute(courseId: String) async throws -> [CourseMaterial] {
        return try await repository.getMaterials(courseId: courseId)
    }
}
