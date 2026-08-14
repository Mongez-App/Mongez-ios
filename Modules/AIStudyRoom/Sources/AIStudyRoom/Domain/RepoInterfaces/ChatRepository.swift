//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation

public protocol ChatRepository {
    func getTask(taskId: String) async throws -> TaskDetailsDTO
    func updateTask(taskId: String, completed: Bool, activeSpentTime: Int) async throws
    func sendMessage(taskId: String, message: String) async throws
    func getChatMessages(taskId: String, page: Int, size: Int) async throws -> ChatHistoryResponseDTO
}
