import Foundation

public struct CourseMaterialDTO: Decodable {
    public let documentId: String?
    public let materialId: String?
    public let filename: String?
    public let chunkCount: Int?
    public let totalPages: Int?
    public let totalChars: Int?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        documentId = try container.decodeIfPresent(String.self, forKey: .documentId)
        materialId = try container.decodeIfPresent(String.self, forKey: .materialId)
        filename = try container.decodeIfPresent(String.self, forKey: .filename)
        chunkCount = try container.decodeIfPresent(Int.self, forKey: .chunkCount)
        totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages)
        totalChars = try container.decodeIfPresent(Int.self, forKey: .totalChars)
    }

    /// The identifier used to reference this material when deleting or updating it.
    public var id: String? {
        materialId ?? documentId
    }

    enum CodingKeys: String, CodingKey {
        case documentId = "document_id"
        case materialId = "material_id"
        case filename
        case chunkCount = "chunk_count"
        case totalPages = "total_pages"
        case totalChars = "total_chars"
    }
}

public extension CourseMaterialDTO {
    func toDomain() -> CourseMaterial {
        return CourseMaterial(
            id: id ?? UUID().uuidString,
            name: filename ?? "Unknown",
            pageCount: totalPages ?? 0,
            fileSizeMB: 0
        )
    }
}