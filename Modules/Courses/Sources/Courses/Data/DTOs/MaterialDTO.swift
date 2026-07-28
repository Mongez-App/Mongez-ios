import Foundation

struct UploadDocumentResponseDTO: Decodable {
    let success: Bool?
    let data: DocumentDTO?
    let message: String?
}

struct DocumentDTO: Decodable {
    let documentId: String?
    let filename: String?
    let chunkCount: Int?
    let totalPages: Int?
    let totalChars: Int?
}

struct DocumentListResponseDTO: Decodable {
    let success: Bool?
    let data: DocumentListDataDTO?
    let message: String?
}

struct DocumentListDataDTO: Decodable {
    let documents: [DocumentDTO]?
}

struct MaterialDTO: Decodable {
    let id: String?
    let fileName: String?
    let contentType: String?
    let fileSizeBytes: Int?
    let pageCount: Int?
    let courseId: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "documentId"
        case fileName = "filename"
        case contentType
        case fileSizeBytes
        case pageCount = "totalPages"
        case courseId
        case createdAt
    }

    init(id: String? = nil, fileName: String? = nil, contentType: String? = nil, fileSizeBytes: Int? = nil, pageCount: Int? = nil, courseId: String? = nil, createdAt: String? = nil) {
        self.id = id
        self.fileName = fileName
        self.contentType = contentType
        self.fileSizeBytes = fileSizeBytes
        self.pageCount = pageCount
        self.courseId = courseId
        self.createdAt = createdAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.fileName = try container.decodeIfPresent(String.self, forKey: .fileName)
        self.contentType = try container.decodeIfPresent(String.self, forKey: .contentType)
        self.fileSizeBytes = try container.decodeIfPresent(Int.self, forKey: .fileSizeBytes)
        self.pageCount = try container.decodeIfPresent(Int.self, forKey: .pageCount)
        self.courseId = try container.decodeIfPresent(String.self, forKey: .courseId)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
    }

    func toDomain() -> Material {
        Material(
            id: id ?? UUID().uuidString,
            fileName: fileName ?? "Unknown",
            contentType: contentType ?? "application/octet-stream",
            fileSizeBytes: fileSizeBytes ?? 0,
            pageCount: pageCount,
            courseId: courseId ?? "",
            uploadId: id,
            createdAt: nil
        )
    }
}

extension DocumentDTO {
    func toMaterialDTO() -> MaterialDTO {
        MaterialDTO(
            id: documentId,
            fileName: filename,
            contentType: nil,
            fileSizeBytes: nil,
            pageCount: totalPages,
            courseId: nil,
            createdAt: nil
        )
    }
}
