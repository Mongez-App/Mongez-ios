import Foundation

public struct CourseTask: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let durationMinutes: Int
    public let isCompleted: Bool
    public let taskDate: String

    public init(id: String, title: String, durationMinutes: Int, isCompleted: Bool, taskDate: String) {
        self.id = id
        self.title = title
        self.durationMinutes = durationMinutes
        self.isCompleted = isCompleted
        self.taskDate = taskDate
    }
}
