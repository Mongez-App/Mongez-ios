//
//  File.swift
//  
//
//  Created by Mazen Amr on 24/07/2026.
//

import Foundation
import Common

public class CourseDetailsRepositoryImpl: CourseDetailsRepository {
    
    private let remoteDataSource: CourseDetailsRemoteDataSource
        
    public init(remoteDataSource: CourseDetailsRemoteDataSource = CourseDetailsRemoteDataSourceImpl()) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func getMaterials(courseId: String) async throws -> [CourseMaterial] {
        let endpoint = CourseMaterialEndPoint.getMaterials(courseId: courseId)
        let materialDTOs = try await NetworkManger.shared.request(
            endpoint: endpoint,
            responseType: [CourseMaterialDTO].self
        )
        return materialDTOs.map { $0.toDomain() }
    }
    
    
public func uploadMaterial(
        courseId: String,
        fileData: Data,
        fileName: String,
        dailyStudyMinutes: Int? = nil,
        preferredDays: String? = nil
    ) async throws -> CourseMaterial {
        
        let dto = try await remoteDataSource.uploadMaterial(
            courseId: courseId,
            fileData: fileData,
            fileName: fileName,
            dailyStudyMinutes: dailyStudyMinutes,
            preferredDays: preferredDays
        )
        
        return dto.toDomain()
    }
    
    public func getTasks(courseId: String) async throws -> [CourseTask] {
        let taskDTOs = try await remoteDataSource.getTasks(courseId: courseId)
        return taskDTOs.map { $0.toDomain() }
    }
    
    public func updateCourse(courseId: String, name: String?, imageUrl: String?, isHidden: Bool?) async throws -> Course {
        let request = UpdateCourseRequestDTO(name: name, image_url: imageUrl, is_hidden: isHidden)
        let dto = try await remoteDataSource.updateCourse(courseId: courseId, request: request)
        return dto.toDomain()
    }

    public func deleteCourse(courseId: String) async throws {
        _ = try await remoteDataSource.deleteCourse(courseId: courseId)
    }

    public func deleteMaterial(courseId: String, materialId: String) async throws {
        _ = try await remoteDataSource.deleteMaterial(courseId: courseId, materialId: materialId)
    }
}
