import Foundation

struct ChatMessageDTO: Decodable {
    let messageId: String?
    let role: String?
    let content: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case messageId
        case role
        case content
        case createdAt
    }

    func toDomain() -> ChatMessage {
        ChatMessage(
            id: messageId ?? UUID().uuidString,
            role: role.map { ChatRole(rawValue: $0) ?? .assistant } ?? .assistant,
            content: content ?? "",
            createdAt: createdAt.flatMap { ISO8601DateFormatter().date(from: $0) } ?? Date()
        )
    }
}
