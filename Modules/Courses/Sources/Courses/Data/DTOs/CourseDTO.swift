import Foundation

struct CourseDTO: Codable {
    var id: String
    var name: String
    var courseCode: String
    var startDate: String
    var examDate: String
    var hasMaterials: Bool
    var completionPercentage: Double
    var isHidden: Bool?
    var imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case courseCode = "course_code"
        case startDate = "start_date"
        case examDate = "exam_date"
        case hasMaterials = "has_materials"
        case completionPercentage = "completion_percentage"
        case isHidden = "is_hidden"
        case imageData = "image_data"
    }
    
    func toDomain() -> Course {
        let dateFormatter = ISO8601DateFormatter()
        return Course(
            id: id,
            name: name,
            courseCode: courseCode,
            startDate: dateFormatter.date(from: startDate) ?? Date(),
            examDate: dateFormatter.date(from: examDate) ?? Date(),
            hasMaterials: hasMaterials,
            completionPercentage: completionPercentage,
            isHidden: isHidden ?? false,
            imageData: imageData
        )
    }
}
