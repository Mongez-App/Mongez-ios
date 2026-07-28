import Foundation
import Common

public protocol AIStudyRoomRemoteDataSourceProtocol {
    func query(courseId: String, text: String) async throws -> QueryResponseDTO
    func getChatHistory(courseId: String) async throws -> ChatHistoryResponseDTO
}

public final class AIStudyRoomRemoteDataSource: AIStudyRoomRemoteDataSourceProtocol {

    public init() {}

    public func query(courseId: String, text: String) async throws -> QueryResponseDTO {
        let body = QueryRequestDTO(query: text, courseId: courseId)
        let bodyData = try JSONEncoder().encode(body)

        let (data, statusCode) = try await NetworkManger.shared.requestRaw(
            endpoint: AIStudyRoomEndpoints.query(body: bodyData)
        )

        let raw = String(data: data, encoding: .utf8) ?? "?"
        print("=== QUERY RESPONSE ===")
        print("Status: \(statusCode)")
        print("Body: \(raw.prefix(2000))")
        print("======================")

        if let wrapper = try? JSONDecoder().decode(QueryResponseWrapperDTO.self, from: data),
           let response = wrapper.data {
            return response
        }

        return try JSONDecoder().decode(QueryResponseDTO.self, from: data)
    }

    public func getChatHistory(courseId: String) async throws -> ChatHistoryResponseDTO {
        let (data, statusCode) = try await NetworkManger.shared.requestRaw(
            endpoint: AIStudyRoomEndpoints.getChatHistory(courseId: courseId)
        )

        let raw = String(data: data, encoding: .utf8) ?? "?"
        print("=== CHAT HISTORY ===")
        print("Status: \(statusCode)")
        print("Body: \(raw.prefix(2000))")
        print("====================")

        if let wrapper = try? JSONDecoder().decode(ChatHistoryWrapperDTO.self, from: data),
           let response = wrapper.data {
            return response
        }

        return try JSONDecoder().decode(ChatHistoryResponseDTO.self, from: data)
    }
}
