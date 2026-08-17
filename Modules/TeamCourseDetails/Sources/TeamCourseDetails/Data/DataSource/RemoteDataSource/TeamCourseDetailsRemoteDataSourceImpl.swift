//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation
import Common

public class TeamCourseDetailsRemoteDataSourceImpl: TeamCourseDetailsRemoteDataSource {
    
    public init() {}
    
    public func getMaterials(courseId: String, organizationId: String) async throws -> TeamCourseMaterialsResponseDTO {
        let endpoint = TeamCourseMaterialEndPoint.getMaterials(courseId: courseId, organizationId: organizationId)
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: TeamCourseMaterialsResponseDTO.self)
    }
    
    public func getTasks(courseId: String) async throws -> TeamCourseTasksResponseDTO {
        let endpoint = TeamCourseTaskEndPoint.getTasks(courseId: courseId)
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: TeamCourseTasksResponseDTO.self)
    }
}
