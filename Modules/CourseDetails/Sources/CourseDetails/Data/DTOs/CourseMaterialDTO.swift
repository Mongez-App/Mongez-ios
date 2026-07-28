import Foundation

public struct CourseMaterialDTO: Decodable {
    public let documentId: String?
    public let filename: String?
    public let chunkCount: Int?
    public let totalPages: Int?
    public let totalChars: Int?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentId = try container.decodeIfPresent(String.self, forKey: .documentId)
        filename = try container.decodeIfPresent(String.self, forKey: .filename)
        chunkCount = try container.decodeIfPresent(Int.self, forKey: .chunkCount)
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
        totalChars = try container.decodeIfPresent(Int.self, forKey: .totalChars)
    }

    enum CodingKeys: String, CodingKey {
        case documentId
        case filename
        case chunkCount
        case totalPages
        case totalChars
    }
}

public extension CourseMaterialDTO {
    func toDomain() -> CourseMaterial {
        return CourseMaterial(
            id: documentId ?? UUID().uuidString,
            name: filename ?? "Unknown",
            pageCount: totalPages ?? 0,
            fileSizeMB: 0
        )
    }
}
