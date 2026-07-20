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
    @StateObject var viewModel: StudyRoomViewModel
    let taskTitle: String
    
    public init(viewModel: StudyRoomViewModel, taskTitle: String) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.taskTitle = taskTitle
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            StudyRoomHeaderView(
                taskTitle: taskTitle,
                onPauseAction: {  },
                onDoneAction: { }
            )
            
            StudyRoomTimerView()
            
            Divider()
                .background(AppTheme.Colors.gray100)
                .padding(.bottom, AppTheme.Spacing.small)
            
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
            
            StudyRoomInputView(
                inputText: $viewModel.inputText,
                onSendAction: { viewModel.sendMessage() }
            )
        }
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .task {
            await viewModel.loadHistory()
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
