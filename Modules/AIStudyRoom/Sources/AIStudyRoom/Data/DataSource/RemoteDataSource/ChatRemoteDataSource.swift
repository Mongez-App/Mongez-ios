//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/08/2026.
//

import Foundation

public protocol ChatRemoteDataSource {
    func getTask(taskId: String) async throws -> TaskDetailsDTO
    func updateTask(taskId: String, request: UpdateTaskRequestDTO) async throws
    func sendMessage(taskId: String, request: SendMessageRequestDTO) async throws
    func getChatMessages(taskId: String, page: Int, size: Int) async throws -> ChatHistoryResponseDTO
}
