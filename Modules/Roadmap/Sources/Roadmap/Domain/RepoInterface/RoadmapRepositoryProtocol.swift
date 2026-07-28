import Foundation

public protocol RoadmapRepositoryProtocol {
    func getRoadmap() async throws -> Roadmap
    func getCourses() async throws -> [Course]
    func addEvent(courseId: String, eventType: String, title: String, dueDate: String, weight: Int) async throws
}
