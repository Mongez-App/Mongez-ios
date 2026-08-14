//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation
import Combine

@MainActor
public class StudyRoomViewModel: ObservableObject {
    @Published public var messages: [ChatMessage] = []
    @Published public var inputText: String = ""
    @Published public var isLoading: Bool = false
    @Published public var elapsedTimeInSeconds: Int = 0
    public let allocatedTimeInMinutes: Int = 25
    private var timerTask: Task<Void, Never>?
    private var currentSessionId: String? = nil
    private let courseId: String
    private let taskId: String
    
    private let getChatHistoryUseCase: GetChatHistoryUseCase
    private let sendMessageUseCase: SendMessageUseCase
    private let updateTaskUseCase: UpdateTaskUseCase
    
    nonisolated public init(
        courseId: String,
        taskId: String,
        activeSpentTime: Int,
        getChatHistoryUseCase: GetChatHistoryUseCase,
        sendMessageUseCase: SendMessageUseCase,
        updateTaskUseCase: UpdateTaskUseCase
    ) {
        self.courseId = courseId
        self.taskId = taskId
        self.getChatHistoryUseCase = getChatHistoryUseCase
        self.sendMessageUseCase = sendMessageUseCase
        self.updateTaskUseCase = updateTaskUseCase
        
        Task { @MainActor in
            self.elapsedTimeInSeconds = activeSpentTime
        }
    }
    
    public var formattedElapsedTime: String {
        let minutes = elapsedTimeInSeconds / 60
        let seconds = elapsedTimeInSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    public var formattedAllocatedTime: String {
        return String(format: "%02d:00", allocatedTimeInMinutes)
    }
    
    public func startTimer() {
        timerTask?.cancel()
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                if !Task.isCancelled {
                    elapsedTimeInSeconds += 1
                }
            }
        }
    }
    
    public func pauseTimer() {
        timerTask?.cancel()
    }
    
    private var hasEndedSession = false
    
    public func endSession(isCompleted: Bool) async {
        if hasEndedSession { return }
        hasEndedSession = true
        
        pauseTimer()
        let activeSpentTimeInSeconds = elapsedTimeInSeconds
        
        do {
            try await updateTaskUseCase.execute(
                taskId: taskId,
                completed: isCompleted,
                activeSpentTime: activeSpentTimeInSeconds
            )
        } catch {
            print("Failed to update task: \(error)")
        }
    }
    
    public func loadHistory() async {
        isLoading = true
        do {
            messages = try await getChatHistoryUseCase.execute(taskId: taskId, page: 0, size: 20)
        } catch {
            print("Failed to load history: \(error)")
        }
        isLoading = false
    }
    
    public func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userText = inputText
        inputText = ""
        let userMessage = ChatMessage(id: UUID().uuidString, role: .user, content: userText, createdAt: Date())
        messages.append(userMessage)
        let assistantMessageId = UUID().uuidString
        let emptyAssistantMessage = ChatMessage(id: assistantMessageId, role: .assistant, content: "...", createdAt: Date())
        messages.append(emptyAssistantMessage)
        
        Task {
            do {
                try await sendMessageUseCase.execute(taskId: taskId, text: userText)
                await loadHistory()
                
            } catch {
                print("Failed to send message: \(error)")
                if let index = messages.firstIndex(where: { $0.id == assistantMessageId }) {
                    messages[index] = ChatMessage(
                        id: assistantMessageId,
                        role: .assistant,
                        content: "Failed to get response. Please try again.",
                        createdAt: Date()
                    )
                }
            }
        }
    }
    
    deinit {
        timerTask?.cancel()
    }
}
