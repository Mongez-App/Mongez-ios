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
    
    public func execute(courseId: String, fileData: Data, fileName: String, sizeBytes: Int,pageCount : Int) async throws -> FinalizeUploadResponseDTO {
        
        let initResponse = try await repository.initializeUpload(
            courseId: courseId,
            fileName: fileName,
            contentType: "application/pdf",
            sizeBytes: sizeBytes,
            pageCount: pageCount,
            deviceUri: "content://local/\(fileName)"
        )
        
        let finalResponse = try await repository.uploadFile(
            materialId: initResponse.material_id,
            fileData: fileData,
            fileName: fileName
        )
        
        return finalResponse
    }
}
