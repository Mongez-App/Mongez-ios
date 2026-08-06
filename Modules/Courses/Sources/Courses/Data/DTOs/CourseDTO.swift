import Foundation

struct CoursesListDataWrapper: Decodable {
    let success: Bool?
    let data: CoursesListInnerData?
    let message: String?
}

struct CoursesListInnerData: Decodable {
    let courses: [CourseDTO]?
}

struct CreateCourseResponseDTO: Decodable {
    let success: Bool?
    let data: CourseDTO?
    let message: String?
}

struct CourseDTO: Decodable {
    let id: String?
    let userId: String?
    let name: String?
    let startDate: String?
    let endDate: String?
    let studyDates: [String]?
    let documentCount: Int?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "courseId"
        case userId
        case name = "courseName"
        case startDate
        case endDate
        case studyDates
        case documentCount
        case createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)

        let decodedName = try container.decodeIfPresent(String.self, forKey: .name)
        if let name = decodedName, !name.isEmpty {
            self.name = name
        } else {
            self.name = nil
        }

        self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate)
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate)
        self.studyDates = try container.decodeIfPresent([String].self, forKey: .studyDates)
        self.documentCount = try container.decodeIfPresent(Int.self, forKey: .documentCount)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
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
            courseCode: "",
            description: nil,
            imageUrl: nil,
            startDate: parseDate(startDate) ?? Date(),
            endDate: parseDate(endDate),
            examDate: Date(),
            hasMaterials: (documentCount ?? 0) > 0,
            completionPercentage: 0.0,
            isHidden: false,
            materialCount: documentCount ?? 0
        )
    }
}

struct CreateCourseRequestDTO: Codable {
    let courseId: String
    let courseName: String
    let code: String
    let startDate: String
    let endDate: String?

    enum CodingKeys: String, CodingKey {
        case courseId = "courseId"
        case courseName = "courseName"
        case code = "code"
        case startDate = "startDate"
        case endDate = "endDate"
    }
}

struct AddCourseFromURLRequestDTO: Codable {
    let url: String
}

struct DeleteCourseResponseDTO: Codable {
    let message: String?
}
