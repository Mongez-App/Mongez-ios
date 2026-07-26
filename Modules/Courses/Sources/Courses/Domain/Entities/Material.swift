import Foundation

public struct Material: Identifiable, Equatable {
    public let id: String
    public let fileName: String
    public let contentType: String
    public let fileSizeBytes: Int
    public let pageCount: Int?
    public let courseId: String
    public let uploadId: String?
    public let createdAt: Date?

    public init(
        id: String = UUID().uuidString,
        fileName: String,
        contentType: String,
        fileSizeBytes: Int,
        pageCount: Int? = nil,
        courseId: String = "",
        uploadId: String? = nil,
        createdAt: Date? = nil
    ) {
        self.id = id
        self.fileName = fileName
        self.contentType = contentType
        self.fileSizeBytes = fileSizeBytes
        self.pageCount = pageCount
        self.courseId = courseId
        self.uploadId = uploadId
        self.createdAt = createdAt
    }
}

