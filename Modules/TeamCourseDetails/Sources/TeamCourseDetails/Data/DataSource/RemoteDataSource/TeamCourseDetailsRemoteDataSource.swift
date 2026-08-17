//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation

public protocol TeamCourseDetailsRemoteDataSource {
    func getMaterials(courseId: String, organizationId: String) async throws -> TeamCourseMaterialsResponseDTO
    func getTasks(courseId: String) async throws -> TeamCourseTasksResponseDTO
}
