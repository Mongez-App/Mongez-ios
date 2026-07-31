//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation

public protocol CourseDetailsRemoteDataSource {
    func getMaterials(courseId: String) async throws -> [CourseMaterialDTO]
    func uploadMaterial(
        courseId: String,
        fileData: Data,
        fileName: String,
        dailyStudyMinutes: Int?,
        preferredDays: String?
    ) async throws -> CourseMaterialDTO
    func updateCourse(courseId: String, request: UpdateCourseRequestDTO) async throws -> CourseDTO
    func deleteCourse(courseId: String) async throws -> EmptyResponseDTO
    func deleteMaterial(courseId: String, materialId: String) async throws -> EmptyResponseDTO
    func getTasks(courseId: String) async throws -> [CourseTaskDTO]
}
