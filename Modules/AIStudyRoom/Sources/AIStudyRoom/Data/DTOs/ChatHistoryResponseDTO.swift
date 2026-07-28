import Foundation

public struct ChatHistoryWrapperDTO: Decodable {
    let success: Bool?
    let data: ChatHistoryResponseDTO?
    let message: String?
}

public struct ChatHistoryResponseDTO: Decodable {
    let messages: [ChatMessageDTO]?
    let hasMore: Bool?

    enum CodingKeys: String, CodingKey {
        case messages
        case hasMore
    }
}
