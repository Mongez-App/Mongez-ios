import Foundation

public struct TeamCourse: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let progress: Double
    
    public init(id: String, name: String, progress: Double) {
        self.id = id
        self.name = name
        self.progress = progress
    }
}
