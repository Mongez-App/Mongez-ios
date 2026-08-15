import Foundation

public class GetTaskUseCase {
    private let repository: ChatRepository
    
    public init(repository: ChatRepository) {
        self.repository = repository
    }
    
    public func execute(taskId: String) async throws -> TaskDetailsDTO {
        return try await repository.getTask(taskId: taskId)
    }
}
