import Foundation

struct AddMaterialResponseDTO: Decodable {
    let materialId: String?
    let uploadUrl: String?

    enum CodingKeys: String, CodingKey {
        case materialId = "material_id"
        case uploadUrl = "upload_url"
    }
}

struct MaterialDTO: Decodable {
    let id: String?
    let fileName: String?
    let contentType: String?
    let fileSizeBytes: Int?
    let pageCount: Int?
    let courseId: String?
    let uploadId: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case _id = "_id"
        case fileName = "file_name"
        case contentType = "content_type"
        case fileSizeBytes = "file_size_bytes"
        case pageCount = "page_count"
        case courseId = "course_id"
        case uploadId = "upload_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedId = try container.decodeIfPresent(String.self, forKey: .id)
        let fallbackId = try container.decodeIfPresent(String.self, forKey: ._id)

        self.id = decodedId ?? fallbackId
        self.fileName = try container.decodeIfPresent(String.self, forKey: .fileName)
        self.contentType = try container.decodeIfPresent(String.self, forKey: .contentType)
        self.fileSizeBytes = try container.decodeIfPresent(Int.self, forKey: .fileSizeBytes)
        self.pageCount = try container.decodeIfPresent(Int.self, forKey: .pageCount)
        self.courseId = try container.decodeIfPresent(String.self, forKey: .courseId)
        self.uploadId = try container.decodeIfPresent(String.self, forKey: .uploadId)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    }

    func toDomain() -> Material {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return Material(
            id: id ?? UUID().uuidString,
            fileName: fileName ?? "Unknown",
            contentType: contentType ?? "application/octet-stream",
            fileSizeBytes: fileSizeBytes ?? 0,
            pageCount: pageCount,
            courseId: courseId ?? "",
            uploadId: uploadId,
            createdAt: createdAt.flatMap { dateFormatter.date(from: $0) }
        )
    }
}

struct AddMaterialMetadataRequestDTO: Codable {
    let fileName: String
    let contentType: String
    let fileSizeBytes: Int
    let pageCount: Int?

    enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
        case contentType = "content_type"
        case fileSizeBytes = "file_size_bytes"
        case pageCount = "page_count"
    }
}

struct UploadMaterialResponseDTO: Codable {
    let message: String?
}

