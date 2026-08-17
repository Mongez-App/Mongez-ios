import Foundation

public struct TeamCourse: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let progress: Double
    public let organizationId: String?
    
    public init(id: String, name: String, progress: Double, organizationId: String? = nil) {
        self.id = id
        self.name = name
        self.progress = progress
        self.organizationId = organizationId
    }
}
