import Foundation

public struct QueryRequestDTO: Codable {
    let query: String
    let courseId: String
}

public struct QueryResponseWrapperDTO: Decodable {
    let success: Bool?
    let data: QueryResponseDTO?
    let message: String?
}

public struct QueryResponseDTO: Decodable {
    let answer: String?
    let sources: [QuerySourceDTO]?
}

public struct QuerySourceDTO: Decodable {
    let documentId: String?
    let filename: String?
    let chunkText: String?
    let relevance: Double?
    let chunkIndex: Int?
    let pageNumber: Int?
}
