////
////  File.swift
////  
////
////  Created by Mazen Amr on 18/07/2026.
////
//
//import Foundation
//
//public class MockChatRepository: ChatRepository {
//    
//    public init(){}
//    
//    public func getHistory(courseId: String) async throws -> [ChatMessage] {
//        try await Task.sleep(nanoseconds: 1_000_000_000)
//        
//        return [
//            ChatMessage(id: "msg_001", role: .user, content: "Explain the difference between a mutex and a semaphore.", createdAt: Date().addingTimeInterval(-100)),
//            ChatMessage(id: "msg_002", role: .assistant, content: "A mutex allows only one thread to hold the lock at a time...", createdAt: Date().addingTimeInterval(-50))
//        ]
//    }
//    
//    public func sendMessageStream(courseId: String, text: String) -> AsyncThrowingStream<String, Error> {
//        AsyncThrowingStream { continuation in
//            Task {
//                let mockWords = "This is a mock streamed response from the AI engine for your query.".components(separatedBy: " ")
//                
//                for word in mockWords {
//                    try await Task.sleep(nanoseconds: 150_000_000)
//                    continuation.yield(word + " ")
//                }
//                
//                continuation.finish()
//            }
//        }
//    }
//}
