//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/08/2026.
//

import Foundation

public class ChatRepositoryImpl: ChatRepository {
    private let remoteDataSource: ChatRemoteDataSource
    
    public init(remoteDataSource: ChatRemoteDataSource = ChatRemoteDataSourceImpl()) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func getTask(taskId: String) async throws -> TaskDetailsDTO {
        return try await remoteDataSource.getTask(taskId: taskId)
    }
    
    public func updateTask(taskId: String, completed: Bool, activeSpentTime: Int) async throws {
        let request = UpdateTaskRequestDTO(completed: completed, active_spent_time: activeSpentTime)
        try await remoteDataSource.updateTask(taskId: taskId, request: request)
    }
    
    public func sendMessage(taskId: String, message: String) async throws {
        let request = SendMessageRequestDTO(message: message)
        try await remoteDataSource.sendMessage(taskId: taskId, request: request)
    }
    
    public func getChatMessages(taskId: String, page: Int, size: Int) async throws -> ChatHistoryResponseDTO {
        return try await remoteDataSource.getChatMessages(taskId: taskId, page: page, size: size)
    }
}
