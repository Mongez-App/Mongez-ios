//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Common
import Foundation

public struct UpdateCourseUseCase {
    private let repository: CourseDetailsRepository
    private let cloudinaryService: CloudinaryServiceProtocol
    
    public init(repository: CourseDetailsRepository, cloudinaryService: CloudinaryServiceProtocol) {
        self.repository = repository
        self.cloudinaryService = cloudinaryService
    }
    
    public func execute(id: String, name: String? = nil, imageData: Data? = nil, oldImageUrl: String? = nil, isHidden: Bool? = nil) async throws -> Course {
        var newImageUrl: String? = nil
        
        // 1. Upload new image if provided
        if let imageData = imageData {
            newImageUrl = try await cloudinaryService.uploadImage(imageData: imageData)
        }
        
        // 2. Update course in backend
        let updatedCourse = try await repository.updateCourse(courseId: id, name: name, imageUrl: newImageUrl, isHidden: isHidden)
        
        // 3. Delete old image from Cloudinary if a new one was uploaded and old one exists
        if newImageUrl != nil, let oldUrl = oldImageUrl, let publicId = extractPublicId(from: oldUrl) {
            do {
                try await cloudinaryService.deleteFile(publicId: publicId, resourceType: "image")
            } catch {
                print("Failed to delete old image from Cloudinary: \(error)")
            }
        }
        
        return updatedCourse
    }
    
    private func extractPublicId(from urlString: String) -> String? {
        guard let url = URL(string: urlString) else { return nil }
        let components = url.pathComponents
        
        // Find the index of "upload"
        guard let uploadIndex = components.firstIndex(of: "upload") else { return nil }
        
        var idComponents = Array(components.suffix(from: uploadIndex + 1))
        
        // Remove version component (e.g. "v1234567890") if present
        if let first = idComponents.first, first.hasPrefix("v"), first.dropFirst().allSatisfy({ $0.isNumber }) {
            idComponents.removeFirst()
        }
        
        guard let last = idComponents.last else { return nil }
        
        // Remove file extension
        let lastWithoutExtension = (last as NSString).deletingPathExtension
        idComponents[idComponents.count - 1] = lastWithoutExtension
        
        return idComponents.joined(separator: "/")
    }
}
