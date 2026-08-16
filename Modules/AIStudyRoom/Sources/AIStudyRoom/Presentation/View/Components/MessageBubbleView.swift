//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation
import SwiftUI
import Common

struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
                Text(message.content)
                    .font(AppTheme.textStyle(size: 16))
                    .foregroundColor(AppTheme.Colors.black100)
                    .padding(AppTheme.Spacing.xSmall)
                    .background(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.6))
                    .cornerRadius(AppTheme.radius.meduim)
            } else {
                if message.content == "..." {
                    TypingIndicatorView()
                } else {
                    Text(message.content)
                        .font(AppTheme.textStyle(size: 16))
                        .foregroundColor(AppTheme.Colors.black100)
                        .padding(AppTheme.Spacing.xSmall)
                        .background(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray100, opacity: 0.6))
                        .cornerRadius(AppTheme.radius.meduim)
                }
                Spacer()
            }
        }
    }
}
