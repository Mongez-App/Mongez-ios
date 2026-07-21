import Foundation

public struct Course: Identifiable, Equatable {
    public let id: String
    public var name: String
    public var courseCode: String
    public var startDate: Date
    public var examDate: Date
    public var hasMaterials: Bool
    public var completionPercentage: Double
    public var isHidden: Bool
    public var imageData: Data?
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        courseCode: String,
        startDate: Date,
        examDate: Date,
        hasMaterials: Bool,
        completionPercentage: Double = 0.0,
        isHidden: Bool = false,
        imageData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.courseCode = courseCode
        self.startDate = startDate
        self.examDate = examDate
        self.hasMaterials = hasMaterials
        self.completionPercentage = completionPercentage
        self.isHidden = isHidden
        self.imageData = imageData
    }
}
