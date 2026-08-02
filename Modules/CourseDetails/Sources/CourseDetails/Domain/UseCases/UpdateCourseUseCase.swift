//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation
public struct UpdateCourseUseCase {
    private let repository: CourseDetailsRepository
    
    public init(repository: CourseDetailsRepository) {
        self.repository = repository
    }
    
    public func execute(courseId: String, name: String? = nil, imageUrl: String? = nil, isHidden: Bool? = nil) async throws -> Course {
        return try await repository.updateCourse(courseId: courseId, name: name, imageUrl: imageUrl, isHidden: isHidden)
    }
}
