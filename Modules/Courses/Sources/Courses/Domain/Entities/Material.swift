import Foundation

public struct Material: Identifiable, Equatable {
    public let id: String
    public let fileName: String
    public let contentType: String
    public let fileSizeBytes: Int
    public let pageCount: Int?
    public let courseId: String
    public let createdAt: Date?
    public let deviceFileUri: String?
    public let status: String?

    public init(
        id: String = UUID().uuidString,
        fileName: String,
        contentType: String,
        fileSizeBytes: Int,
        pageCount: Int? = nil,
        courseId: String = "",
        createdAt: Date? = nil,
        deviceFileUri: String? = nil,
        status: String? = nil
    ) {
        self.id = id
        self.fileName = fileName
        self.contentType = contentType
        self.fileSizeBytes = fileSizeBytes
        self.pageCount = pageCount
        self.courseId = courseId
        self.createdAt = createdAt
        self.deviceFileUri = deviceFileUri
        self.status = status
    }
}
