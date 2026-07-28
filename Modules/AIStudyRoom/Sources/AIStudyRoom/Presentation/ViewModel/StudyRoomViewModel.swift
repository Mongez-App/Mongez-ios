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
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    
    @Published var elapsedTimeInSeconds: Int = 0
    let allocatedTimeInMinutes: Int = 25
    private var timerTask: Task<Void, Never>?
    
    private let courseId: String
    private let getChatHistoryUseCase: GetChatHistoryUseCase
    private let sendMessageUseCase: SendMessageUseCase
    
    public init(courseId: String, getChatHistoryUseCase: GetChatHistoryUseCase, sendMessageUseCase: SendMessageUseCase) {
        self.courseId = courseId
        self.getChatHistoryUseCase = getChatHistoryUseCase
        self.sendMessageUseCase = sendMessageUseCase
    }
    
    var formattedElapsedTime: String {
        let minutes = elapsedTimeInSeconds / 60
        let seconds = elapsedTimeInSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var formattedAllocatedTime: String {
        return String(format: "%02d:00", allocatedTimeInMinutes)
    }
    
    func startTimer() {
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
    
    func pauseTimer() {
        timerTask?.cancel()
    }
    
    func loadHistory() async {
        isLoading = true
        do {
            messages = try await getChatHistoryUseCase.execute(courseId: courseId)
        } catch {
            print("Failed to load history: \(error)")
        }
        isLoading = false
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userText = inputText
        inputText = ""
        
        let userMessage = ChatMessage(id: UUID().uuidString, role: .user, content: userText, createdAt: Date())
        messages.append(userMessage)
        
        let assistantMessageId = UUID().uuidString
        let emptyAssistantMessage = ChatMessage(id: assistantMessageId, role: .assistant, content: "", createdAt: Date())
        messages.append(emptyAssistantMessage)
        
        Task {
            do {
                let stream = sendMessageUseCase.execute(courseId: courseId, text: userText)
                for try await chunk in stream {
                    if let index = messages.firstIndex(where: { $0.id == assistantMessageId }) {
                        messages[index] = ChatMessage(
                            id: assistantMessageId,
                            role: .assistant,
                            content: messages[index].content + chunk,
                            createdAt: messages[index].createdAt
                        )
                    }
                }
            } catch {
                if let index = messages.firstIndex(where: { $0.id == assistantMessageId }) {
                    messages[index] = ChatMessage(
                        id: assistantMessageId,
                        role: .assistant,
                        content: error.localizedDescription,
                        createdAt: messages[index].createdAt
                    )
                }
            }
        }
    }
    
    deinit {
        timerTask?.cancel()
    }
}
