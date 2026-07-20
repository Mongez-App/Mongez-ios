//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation

public struct SendMessageUseCase {
    let repository: ChatRepository
    
    public init(repository: ChatRepository) {
        self.repository = repository
    }
    
    func execute(courseId: String, text: String) -> AsyncThrowingStream<String, Error> {
        return repository.sendMessageStream(courseId: courseId, text: text)
    }
}
