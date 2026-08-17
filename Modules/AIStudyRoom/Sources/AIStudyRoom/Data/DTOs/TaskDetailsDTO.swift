import Foundation

public struct TaskDetailsDTO: Codable {
    public let id: String
    public let title: String
    public let duration_minutes: Int
    public let active_spent_time: Int
    public let description: String?
    public let covered_sections: String?
}
