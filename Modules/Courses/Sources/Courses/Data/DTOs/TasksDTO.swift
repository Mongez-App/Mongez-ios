import Foundation

struct CreateTasksRequestDTO: Codable {
    let quizQuestionsPerTask: Int
}

struct TasksListWrapperDTO: Decodable {
    let success: Bool?
    let data: TasksListDataDTO?
    let message: String?
}

struct TasksListDataDTO: Decodable {
    let courseId: String?
    let taskCount: Int?
    let tasks: [CourseTaskDTO]?
}

struct CourseTaskDTO: Decodable {
    let id: String?
    let title: String?
    let estimatedTime: Int?
    let priority: Int?
    let studyDate: String?
    let dayNumber: Int?
    let summary: String?

    enum CodingKeys: String, CodingKey {
        case id = "taskId"
        case title
        case estimatedTime
        case priority
        case studyDate
        case dayNumber
        case summary
    }

    func toDomain() -> CourseTask {
        CourseTask(
            id: id ?? UUID().uuidString,
            title: title ?? "Untitled",
            durationMinutes: estimatedTime ?? 0,
            isCompleted: false,
            taskDate: studyDate ?? ""
        )
    }
}
