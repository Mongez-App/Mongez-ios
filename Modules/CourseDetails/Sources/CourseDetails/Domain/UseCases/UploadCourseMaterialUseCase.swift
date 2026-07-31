//
//  File.swift
//  
//
//  Created by Mazen Amr on 24/07/2026.
//

import Foundation

public class UploadCourseMaterialUseCase {
    private let repository: CourseDetailsRepository
    
    public init(repository: CourseDetailsRepository) {
        self.repository = repository
    }
    
    public func execute(
        courseId: String,
        fileData: Data,
        fileName: String,
        dailyStudyMinutes: Int? = nil,
        preferredDays: String? = nil
    ) async throws -> CourseMaterial {
        return try await repository.uploadMaterial(
            courseId: courseId,
            fileData: fileData,
            fileName: fileName,
            dailyStudyMinutes: dailyStudyMinutes,
            preferredDays: preferredDays
        )
    }
}
