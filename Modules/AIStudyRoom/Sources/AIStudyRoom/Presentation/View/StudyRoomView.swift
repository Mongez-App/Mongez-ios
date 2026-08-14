//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct StudyRoomView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: StudyRoomViewModel
    let taskTitle: String
    @State private var isPaused = false
    @State private var alertType: EndSessionAlertType? = nil
    
    public init(viewModel: StudyRoomViewModel, taskTitle: String) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.taskTitle = taskTitle
    }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    StudyRoomHeaderView(
                        taskTitle: taskTitle,
                        isPaused: $isPaused,
                        onTogglePause: { isPaused ? viewModel.pauseTimer() : viewModel.startTimer() },
                        onDoneAction: {
                            viewModel.pauseTimer()
                            alertType = .complete
                        },
                        onBackAction: {
                            viewModel.pauseTimer()
                            alertType = .incomplete
                        }
                    )
                    
                    StudyRoomTimerView(
                        elapsedTime: viewModel.formattedElapsedTime,
                        allocatedTime: viewModel.formattedAllocatedTime
                    )
                    .padding(.horizontal, AppTheme.Spacing.small)
                }
                .padding(.bottom, AppTheme.Spacing.small)
                .background(AppTheme.Colors.white100.appShadow(
                    opacity: 0.15,
                    radius: 2.5,
                    y: 1
                ))
                .zIndex(1)
                
                ZStack {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: AppTheme.Spacing.medium) {
                                ForEach(viewModel.messages) { message in
                                    MessageBubbleView(message: message)
                                        .id(message.id)
                                }
                            }
                            .padding(AppTheme.Spacing.small)
                        }
                        .onChange(of: viewModel.messages.count) { _ in
                            scrollToBottom(proxy: proxy)
                        }
                        .onChange(of: viewModel.messages.last?.content) { _ in
                            scrollToBottom(proxy: proxy)
                        }
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(AppTheme.Colors.purple200)
                    }
                }
                
                StudyRoomInputView(
                    inputText: $viewModel.inputText,
                    onSendAction: { viewModel.sendMessage() }
                )
            }
            .background(AppTheme.Colors.white100.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .task {
                viewModel.startTimer()
                await viewModel.loadHistory()
            }
            .onDisappear {
                viewModel.pauseTimer()
                Task {
                    await viewModel.endSession(isCompleted: false)
                }
            }
            
            if let type = alertType {
                EndSessionAlertView(
                    type: type,
                    onEndSession: {
                        Task {
                            await viewModel.endSession(isCompleted: type == .complete)
                            alertType = nil
                            dismiss()
                        }
                    },
                    onKeepStudying: {
                        alertType = nil
                        viewModel.startTimer()
                    }
                )
                .zIndex(2)
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            withAnimation {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}
