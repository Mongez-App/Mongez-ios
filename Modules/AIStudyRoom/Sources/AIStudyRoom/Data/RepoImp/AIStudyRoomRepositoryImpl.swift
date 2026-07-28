import Foundation

public class AIStudyRoomRepositoryImpl: ChatRepository {
    private let remoteDataSource: AIStudyRoomRemoteDataSourceProtocol

    public init(remoteDataSource: AIStudyRoomRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    public func getHistory(courseId: String) async throws -> [ChatMessage] {
        let response = try await remoteDataSource.getChatHistory(courseId: courseId)
        return response.messages?.map { $0.toDomain() } ?? []
    }

    public func sendMessageStream(courseId: String, text: String) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let response = try await remoteDataSource.query(courseId: courseId, text: text)
                    let answer = response.answer ?? ""
                    if answer.lowercased().contains("no relevant content") {
                        continuation.finish(throwing: ChatError.noDocuments)
                        return
                    }
                    continuation.yield(answer)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

enum ChatError: Error, LocalizedError {
    case noDocuments

    var errorDescription: String? {
        switch self {
        case .noDocuments:
            return "This course has no materials yet. Upload a PDF first so I can help you."
        }
    }
}
