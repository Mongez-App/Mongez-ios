//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation

public protocol ChatRepository {
    func getHistory(courseId: String) async throws -> [ChatMessage]
    func sendMessageStream(courseId: String, text: String) -> AsyncThrowingStream<String, Error>
}
