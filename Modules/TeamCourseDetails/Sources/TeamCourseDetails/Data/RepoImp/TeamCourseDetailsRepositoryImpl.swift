//
//  File.swift
//  
//
//  Created by Mazen Amr on 24/07/2026.
//

import Foundation
import Common

public class TeamCourseDetailsRepositoryImpl: TeamCourseDetailsRepository {
    
    private let remoteDataSource: TeamCourseDetailsRemoteDataSource
        
    public init(remoteDataSource: TeamCourseDetailsRemoteDataSource = TeamCourseDetailsRemoteDataSourceImpl()) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func getMaterials(courseId: String, organizationId: String) async throws -> [TeamCourseMaterial] {
        let response = try await remoteDataSource.getMaterials(courseId: courseId, organizationId: organizationId)
        return response.materials?.map { $0.toDomain() } ?? []
    }
    
    
    public func getTasks(courseId: String) async throws -> [TeamCourseTask] {
        let response = try await remoteDataSource.getTasks(courseId: courseId)
        return response.data.map { $0.toDomain() }
    }
}
