//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation

public struct ChatMessageDTO: Decodable {
    public let message_id: String
    public let role: String
    public let content: String
    public let created_at: String
}

public extension ChatMessageDTO {
    func toDomain() -> ChatMessage {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = formatter.date(from: created_at) ?? Date()
        let mappedRole: ChatRole = role.lowercased() == "user" ? .user : .assistant
        
        return ChatMessage(
            id: message_id,
            role: mappedRole,
            content: content,
            createdAt: date
        )
    }
}
