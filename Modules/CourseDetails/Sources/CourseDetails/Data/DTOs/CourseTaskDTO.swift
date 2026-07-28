import Foundation

public struct CourseTaskDTO: Decodable {
    public let id: String?
    public let title: String?
    public let estimatedTime: Int?
    public let priority: Int?
    public let studyDate: String?
    public let dayNumber: Int?

    enum CodingKeys: String, CodingKey {
        case id = "taskId"
        case title
        case estimatedTime
        case priority
        case studyDate
        case dayNumber
    }
}

public extension CourseTaskDTO {
    func toDomain(group: TaskGroup) -> CourseTask {
        return CourseTask(
            id: id ?? UUID().uuidString,
            title: title ?? "Untitled",
            durationMinutes: estimatedTime ?? 0,
            priority: TaskPriority(rawValue: priority.map { $0 >= 667 ? "HIGH" : $0 >= 334 ? "MEDIUM" : "LOW" } ?? "MEDIUM") ?? .medium,
            isCompleted: false,
            group: group
        )
    }
}
