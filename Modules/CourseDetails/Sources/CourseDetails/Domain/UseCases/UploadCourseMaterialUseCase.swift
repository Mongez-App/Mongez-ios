//
//  File.swift
//  
//
//  Created by Mazen Amr on 24/07/2026.
//

import Common
import Foundation

public class UploadCourseMaterialUseCase {
    private let repository: CourseDetailsRepository
    private let cloudinaryService: CloudinaryServiceProtocol
    
    public init(repository: CourseDetailsRepository, cloudinaryService: CloudinaryServiceProtocol) {
        self.repository = repository
        self.cloudinaryService = cloudinaryService
    }
    
    public func execute(courseId: String, fileData: Data, fileName: String, sizeBytes: Int, pageCount: Int) async throws -> UploadMaterialResponseDTO {
        
        // 1. Upload to Cloudinary
        let materialPath = try await cloudinaryService.uploadPDF(fileData: fileData, fileName: fileName)
        
        // 2. Send the URL to backend via initializeUpload inside deviceUri
        let initResponse = try await repository.initializeUpload(
            courseId: courseId,
            fileName: fileName,
            contentType: "application/pdf",
            sizeBytes: sizeBytes,
            pageCount: pageCount,
            deviceUri: materialPath
        )
        
        return initResponse
    }
}
