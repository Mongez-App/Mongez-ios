import Foundation

public enum CourseType: String, Codable, Equatable {
    case materialCourse = "MATERIAL_COURSE"
    case urlCourse = "URL_COURSE"
    case teamCourse = "TEAM_COURSE"
}

public struct Course: Identifiable, Equatable {
    public let id: String
    public var name: String
    public var courseCode: String
    public var description: String?
    public var imageUrl: String?
    public var startDate: Date
    public var endDate: Date?
    public var examDate: Date
    public var courseType: CourseType
    public var materialUrl: String?
    public var completionPercentage: Double
    public var isHidden: Bool
    public var imageData: Data?
    public var materialCount: Int
    public var hasMaterials: Bool
    public var organizationId: String?

    public init(
        id: String = UUID().uuidString,
        name: String,
        courseCode: String = "",
        description: String? = nil,
        imageUrl: String? = nil,
        startDate: Date = Date(),
        endDate: Date? = nil,
        examDate: Date = Date(),
        courseType: CourseType = .materialCourse,
        materialUrl: String? = nil,
        completionPercentage: Double = 0.0,
        isHidden: Bool = false,
        imageData: Data? = nil,
        materialCount: Int = 0,
        hasMaterials: Bool = false,
        organizationId: String? = nil
    ) {
        self.id = id
        self.name = name
        self.courseCode = courseCode
        self.description = description
        self.imageUrl = imageUrl
        self.startDate = startDate
        self.endDate = endDate
        self.examDate = examDate
        self.courseType = courseType
        self.materialUrl = materialUrl
        self.completionPercentage = completionPercentage
        self.isHidden = isHidden
        self.imageData = imageData
        self.materialCount = materialCount
        self.hasMaterials = hasMaterials
        self.organizationId = organizationId
    }
}
