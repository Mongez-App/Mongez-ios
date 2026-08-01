import Foundation

struct CoursesListResponseDTO: Codable {
    let courses: [CourseDTO]?
    let message: String?
}

struct CreateCourseResponseDTO: Codable {
    let course: CourseDTO?
    let message: String?
}

struct CourseDTO: Codable {
    let id: String?
    let userId: String?
    let name: String?
    let courseCode: String?
    let description: String?
    let imageUrl: String?
    let startDate: String?
    let endDate: String?
    let examDate: String?
    let courseType: String?
    let materialUrl: String?
    let completionPercentage: Double?
    let isHidden: Bool?
    let materialCount: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case _id = "_id"
        case userId = "user_id"
        case name
        case courseCode = "course_code"
        case description
        case imageUrl = "image_url"
        case startDate = "start_date"
        case endDate = "end_date"
        case examDate = "exam_date"
        case courseType = "course_type"
        case materialUrl = "material_url"
        case completionPercentage = "completion_percentage"
        case isHidden = "is_hidden"
        case materialCount = "material_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let idString = try container.decodeIfPresent(String.self, forKey: .id) {
            self.id = idString
        } else if let idString = try container.decodeIfPresent(String.self, forKey: ._id) {
            self.id = idString
        } else {
            self.id = nil
        }

        userId = try container.decodeIfPresent(String.self, forKey: .userId)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        courseCode = try container.decodeIfPresent(String.self, forKey: .courseCode)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        examDate = try container.decodeIfPresent(String.self, forKey: .examDate)
        courseType = try container.decodeIfPresent(String.self, forKey: .courseType)
        materialUrl = try container.decodeIfPresent(String.self, forKey: .materialUrl)
        completionPercentage = try container.decodeIfPresent(Double.self, forKey: .completionPercentage)
        isHidden = try container.decodeIfPresent(Bool.self, forKey: .isHidden)
        materialCount = try container.decodeIfPresent(Int.self, forKey: .materialCount)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: ._id)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(courseCode, forKey: .courseCode)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
        try container.encodeIfPresent(startDate, forKey: .startDate)
        try container.encodeIfPresent(endDate, forKey: .endDate)
        try container.encodeIfPresent(examDate, forKey: .examDate)
        try container.encodeIfPresent(courseType, forKey: .courseType)
        try container.encodeIfPresent(materialUrl, forKey: .materialUrl)
        try container.encodeIfPresent(completionPercentage, forKey: .completionPercentage)
        try container.encodeIfPresent(isHidden, forKey: .isHidden)
        try container.encodeIfPresent(materialCount, forKey: .materialCount)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }

    func toDomain() -> Course {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let fallbackFormatter = ISO8601DateFormatter()
        fallbackFormatter.formatOptions = [.withInternetDateTime]

        func parseDate(_ string: String?) -> Date? {
            guard let string = string else { return nil }
            return dateFormatter.date(from: string) ?? fallbackFormatter.date(from: string)
        }

        return Course(
            id: id ?? UUID().uuidString,
            name: name ?? "Untitled",
            courseCode: courseCode ?? "",
            description: description,
            imageUrl: imageUrl,
            startDate: parseDate(startDate) ?? Date(),
            endDate: parseDate(endDate),
            examDate: parseDate(examDate) ?? Date(),
            courseType: CourseType(rawValue: courseType ?? "MATERIAL_COURSE") ?? .materialCourse,
            materialUrl: materialUrl,
            completionPercentage: completionPercentage ?? 0.0,
            isHidden: isHidden ?? false,
            materialCount: materialCount ?? 0
        )
    }
}

struct CreateCourseRequestDTO: Codable {
    let name: String
    let courseCode: String?
    let imageUrl: String?
    let startDate: String
    let examDate: String
    let courseType: String
    let materialUrl: String?

    enum CodingKeys: String, CodingKey {
        case name
        case courseCode = "course_code"
        case imageUrl = "image_url"
        case startDate = "start_date"
        case examDate = "exam_date"
        case courseType = "course_type"
        case materialUrl = "material_url"
    }
}

struct UpdateCourseRequestDTO: Codable {
    let name: String?
    let imageUrl: String?
    let isHidden: Bool?

    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl = "image_url"
        case isHidden = "is_hidden"
    }
}

struct DeleteCourseResponseDTO: Codable {
    let message: String?
}
