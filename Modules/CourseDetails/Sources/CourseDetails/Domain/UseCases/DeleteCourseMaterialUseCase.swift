import Foundation

public struct DeleteCourseMaterialUseCase {
    private let repository: CourseDetailsRepository
    
    public init(repository: CourseDetailsRepository) {
        self.repository = repository
    }
    
    public func execute(courseId: String, materialId: String) async throws {
        try await repository.deleteMaterial(courseId: courseId, materialId: materialId)
    }
}
