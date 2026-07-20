//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation
public struct GetChatHistoryUseCase {
    let repository: ChatRepository
    
    public init(repository: ChatRepository) {
        self.repository = repository
    }
    func execute(courseId: String) async throws -> [ChatMessage] {
        return try await repository.getHistory(courseId: courseId)
    }
}
