import Foundation

public class UpdateTaskUseCase {
    private let repository: ChatRepository
    
    public init(repository: ChatRepository) {
        self.repository = repository
    }
    
    public func execute(taskId: String, completed: Bool, activeSpentTime: Int) async throws {
        try await repository.updateTask(taskId: taskId, completed: completed, activeSpentTime: activeSpentTime)
    }
}
