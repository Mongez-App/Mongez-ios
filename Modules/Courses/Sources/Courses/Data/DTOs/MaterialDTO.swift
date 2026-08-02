import Foundation

struct MaterialDTO: Decodable {
    let id: String?
    let fileName: String?
    let contentType: String?
    let fileSizeBytes: Int?
    let pageCount: Int?
    let courseId: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case _id = "_id"
        case materialId = "material_id"
        case fileName = "file_name"
        case name
        case contentType = "content_type"
        case fileSizeBytes = "file_size_bytes"
        case fileSizeMB = "file_size_mb"
        case pageCount = "page_count"
        case courseId = "course_id"
        case createdAt = "created_at"
        case uploadedAt = "uploaded_at"
        case updatedAt = "updated_at"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let decodedId = try container.decodeIfPresent(String.self, forKey: .id)
        let fallbackId = try container.decodeIfPresent(String.self, forKey: ._id)
        let materialId = try container.decodeIfPresent(String.self, forKey: .materialId)
        self.id = decodedId ?? fallbackId ?? materialId

        let decodedFileName = try container.decodeIfPresent(String.self, forKey: .fileName)
        let fallbackFileName = try container.decodeIfPresent(String.self, forKey: .name)
        self.fileName = decodedFileName ?? fallbackFileName

        self.contentType = try container.decodeIfPresent(String.self, forKey: .contentType)
        
        if let bytes = try container.decodeIfPresent(Int.self, forKey: .fileSizeBytes) {
            self.fileSizeBytes = bytes
        } else if let mb = try container.decodeIfPresent(Double.self, forKey: .fileSizeMB) {
            self.fileSizeBytes = Int(mb * 1024 * 1024)
        } else {
            self.fileSizeBytes = nil
        }

        self.pageCount = try container.decodeIfPresent(Int.self, forKey: .pageCount)
        self.courseId = try container.decodeIfPresent(String.self, forKey: .courseId)
        
        let decodedCreatedAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        let fallbackCreatedAt = try container.decodeIfPresent(String.self, forKey: .uploadedAt)
        self.createdAt = decodedCreatedAt ?? fallbackCreatedAt
        
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    }

    func toDomain() -> Material {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let fallbackFormatter = ISO8601DateFormatter()
        fallbackFormatter.formatOptions = [.withInternetDateTime]

        return Material(
            id: id ?? UUID().uuidString,
            fileName: fileName ?? "Unknown",
            contentType: contentType ?? "application/octet-stream",
            fileSizeBytes: fileSizeBytes ?? 0,
            pageCount: pageCount,
            courseId: courseId ?? "",
            createdAt: createdAt.flatMap { dateFormatter.date(from: $0) ?? fallbackFormatter.date(from: $0) }
        )
    }
}

struct MaterialsListResponseDTO: Decodable {
    let materials: [MaterialDTO]?
    let message: String?
}

struct AddMaterialResponseDTO: Decodable {
    let material: MaterialDTO?
    let message: String?
}

struct DeleteMaterialResponseDTO: Decodable {
    let message: String?
}
