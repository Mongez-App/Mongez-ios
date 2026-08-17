//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation

public struct SendMessageUseCase {
    private let repository: ChatRepository
    
    public init(repository: ChatRepository) {
        self.repository = repository
    }
    
    public func execute(taskId: String, text: String) async throws {
        try await repository.sendMessage(taskId: taskId, message: text)
    }
}
