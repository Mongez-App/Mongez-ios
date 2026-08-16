import Foundation

import Common

public struct DeleteCourseMaterialUseCase {
    private let repository: CourseDetailsRepository
    private let cloudinaryService: CloudinaryServiceProtocol
    
    public init(repository: CourseDetailsRepository, cloudinaryService: CloudinaryServiceProtocol) {
        self.repository = repository
        self.cloudinaryService = cloudinaryService
    }
    
    public func execute(courseId: String, materialId: String, materialPath: String?) async throws {
        // 1. Delete from backend first
        try await repository.deleteMaterial(courseId: courseId, materialId: materialId)
        
        // 2. Extract public_id and delete from Cloudinary
        if let path = materialPath, let publicId = extractPublicId(from: path) {
            do {
                try await cloudinaryService.deleteFile(publicId: publicId, resourceType: "image")
            } catch {
                print("Failed to delete from Cloudinary: \(error)")
            }
        }
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
