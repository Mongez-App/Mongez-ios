import Foundation

public struct CourseEvent: Identifiable, Equatable {
    public let id: String
    public let eventType: String
    public let title: String
    public let dueDate: String
    public let weight: Int
    public let courseId: String

    public init(id: String, eventType: String, title: String, dueDate: String, weight: Int, courseId: String) {
        self.id = id
        self.eventType = eventType
        self.title = title
        self.dueDate = dueDate
        self.weight = weight
        self.courseId = courseId
    }
}
