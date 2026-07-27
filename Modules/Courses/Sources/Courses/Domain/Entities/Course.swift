import Foundation

public struct Course: Identifiable, Equatable {
    public let id: String
    public var name: String
    public var courseCode: String
    public var description: String?
    public var imageUrl: String?
    public var startDate: Date
    public var endDate: Date?
    public var examDate: Date
    public var hasMaterials: Bool
    public var completionPercentage: Double
    public var isHidden: Bool
    public var imageData: Data?
    public var materialCount: Int

    public init(
        id: String = UUID().uuidString,
        name: String,
        courseCode: String = "",
        description: String? = nil,
        imageUrl: String? = nil,
        startDate: Date = Date(),
        endDate: Date? = nil,
        examDate: Date = Date(),
        hasMaterials: Bool = false,
        completionPercentage: Double = 0.0,
        isHidden: Bool = false,
        imageData: Data? = nil,
        materialCount: Int = 0
    ) {
        self.id = id
        self.name = name
        self.courseCode = courseCode
        self.description = description
        self.imageUrl = imageUrl
        self.startDate = startDate
        self.endDate = endDate
        self.examDate = examDate
        self.hasMaterials = hasMaterials
        self.completionPercentage = completionPercentage
        self.isHidden = isHidden
        self.imageData = imageData
        self.materialCount = materialCount
    }
}

