//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/08/2026.
//

import Foundation
import Swinject
import Common

public class ChatAssembly: DIAssembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(ChatRemoteDataSource.self) { _ in
            ChatRemoteDataSourceImpl()
        }
        
        container.register(ChatRepository.self) { resolver in
            let remoteDataSource = resolver.resolve(ChatRemoteDataSource.self)!
            return ChatRepositoryImpl(remoteDataSource: remoteDataSource)
        }
        
        container.register(GetChatHistoryUseCase.self) { resolver in
            let repository = resolver.resolve(ChatRepository.self)!
            return GetChatHistoryUseCase(repository: repository)
        }
        
        container.register(SendMessageUseCase.self) { resolver in
            let repository = resolver.resolve(ChatRepository.self)!
            return SendMessageUseCase(repository: repository)
        }
        
        container.register(UpdateTaskUseCase.self) { resolver in
            let repository = resolver.resolve(ChatRepository.self)!
            return UpdateTaskUseCase(repository: repository)
        }
        
        container.register(GetTaskUseCase.self) { resolver in
            let repository = resolver.resolve(ChatRepository.self)!
            return GetTaskUseCase(repository: repository)
        }
        
        container.register(StudyRoomViewModel.self) { (resolver, taskId: String, taskTitle: String) in
            return StudyRoomViewModel(
                taskId: taskId,
                taskTitle: taskTitle,
                getTaskUseCase: resolver.resolve(GetTaskUseCase.self)!,
                getChatHistoryUseCase: resolver.resolve(GetChatHistoryUseCase.self)!,
                sendMessageUseCase: resolver.resolve(SendMessageUseCase.self)!,
                updateTaskUseCase: resolver.resolve(UpdateTaskUseCase.self)!
            )
        }
    }
}
