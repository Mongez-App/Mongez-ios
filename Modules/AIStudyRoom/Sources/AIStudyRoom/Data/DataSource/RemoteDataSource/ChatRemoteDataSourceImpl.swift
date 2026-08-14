//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/08/2026.
//

import Foundation
import Common

public class ChatRemoteDataSourceImpl: ChatRemoteDataSource {
    public init() {}
    
    public func updateTask(taskId: String, request: UpdateTaskRequestDTO) async throws {
        let endpoint = ChatEndPoint.updateTask(taskId: taskId, request: request)
        _ = try await NetworkManger.shared.request(endpoint: endpoint, responseType: EmptyResponseDTO.self)
    }
    
    public func sendMessage(taskId: String, request: SendMessageRequestDTO) async throws {
        let endpoint = ChatEndPoint.sendMessage(taskId: taskId, request: request)
        _ = try await NetworkManger.shared.request(endpoint: endpoint, responseType: EmptyResponseDTO.self)
    }
    
    public func getChatMessages(taskId: String, page: Int, size: Int) async throws -> ChatHistoryResponseDTO {
        let endpoint = ChatEndPoint.getMessages(taskId: taskId, page: page, size: size)
        return try await NetworkManger.shared.request(endpoint: endpoint, responseType: ChatHistoryResponseDTO.self)
    }
}
