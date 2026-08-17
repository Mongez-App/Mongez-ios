//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation

public protocol CourseDetailsRemoteDataSource {
    func getMaterials(courseId: String) async throws -> [CourseMaterialDTO]
    func initializeUpload(courseId: String, request: InitUploadRequestDTO) async throws -> UploadMaterialResponseDTO
    func uploadFile(materialId: String, fileData: Data, fileName: String) async throws -> FinalizeUploadResponseDTO
    func updateCourse(courseId: String, request: UpdateCourseRequestDTO) async throws -> CourseDTO
    func deleteCourse(courseId: String) async throws -> EmptyResponseDTO
    func deleteMaterial(courseId: String, materialId: String) async throws -> EmptyResponseDTO
    func getTasks(courseId: String) async throws -> CourseTasksResponseDTO
}
