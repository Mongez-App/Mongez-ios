import Foundation

public struct UpdateTaskRequestDTO: Encodable {
    public let completed: Bool
    public let active_spent_time: Int
    
    public init(completed: Bool, active_spent_time: Int) {
        self.completed = completed
        self.active_spent_time = active_spent_time
    }
}
