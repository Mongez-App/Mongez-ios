//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation

public struct GetChatHistoryUseCase {
    private let repository: ChatRepository
    
    public init(repository: ChatRepository) {
        self.repository = repository
    }
    
    public func execute(taskId: String, page: Int = 0, size: Int = 20) async throws -> [ChatMessage] {
        let responseDTO = try await repository.getChatMessages(taskId: taskId, page: page, size: size)
        return responseDTO.messages.map { $0.toDomain() }
    }
}
