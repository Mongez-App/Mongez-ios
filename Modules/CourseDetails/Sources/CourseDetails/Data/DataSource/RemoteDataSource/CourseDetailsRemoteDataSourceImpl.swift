//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation
import Common

public class CourseDetailsRemoteDataSourceImpl: CourseDetailsRemoteDataSource {
    
    public init() {}
    
    public func getMaterials(courseId: String) async throws -> [CourseMaterialDTO] {
        let endpoint = CourseMaterialEndPoint.getMaterials(courseId: courseId)
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: [CourseMaterialDTO].self)
    }
    public func initializeUpload(courseId: String, request: InitUploadRequestDTO) async throws -> UploadMaterialResponseDTO {
        let payload = try JSONEncoder().encode(request)
        let endpoint = CourseMaterialEndPoint.initializeUpload(courseId: courseId, payload: payload)
        
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: UploadMaterialResponseDTO.self)
    }
    
    public func uploadFile(materialId: String, fileData: Data, fileName: String) async throws -> FinalizeUploadResponseDTO {
        let boundary = "Boundary-\(UUID().uuidString)"
        let multipartBody = createMultipartBody(
            fileData: fileData,
            boundary: boundary,
            fieldName: "file",
            fileName: fileName,
            mimeType: "application/pdf"
        )
        
        let endpoint = CourseMaterialEndPoint.uploadFile(
            materialId: materialId,
            payload: multipartBody,
            boundary: boundary
        )
        
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: FinalizeUploadResponseDTO.self)
    }
    
    
    private func createMultipartBody(
        fileData: Data,
        boundary: String,
        fieldName: String,
        fileName: String,
        mimeType: String
    ) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append(fileData)
        body.append("\(lineBreak)".data(using: .utf8)!)
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        return body
    }
    
    public func updateCourse(courseId: String, request: UpdateCourseRequestDTO) async throws -> CourseDTO {
        let payload = try JSONEncoder().encode(request)
        let endpoint = CourseEndPoint.updateCourse(courseId: courseId, payload: payload)
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: CourseDTO.self)
    }

    public func deleteCourse(courseId: String) async throws -> EmptyResponseDTO {
        let endpoint = CourseEndPoint.deleteCourse(courseId: courseId)
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: EmptyResponseDTO.self)
    }
    
    public func deleteMaterial(courseId: String, materialId: String) async throws -> EmptyResponseDTO {
        let endpoint = CourseEndPoint.deleteMaterial(courseId: courseId, materialId: materialId)
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: EmptyResponseDTO.self)
    }
    
    public func getTasks(courseId: String) async throws -> CourseTasksResponseDTO {
        let endpoint = CourseTaskEndPoint.getTasks(courseId: courseId)
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: CourseTasksResponseDTO.self)
    }
}
