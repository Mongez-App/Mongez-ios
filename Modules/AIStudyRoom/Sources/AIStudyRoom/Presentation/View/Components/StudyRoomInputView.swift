//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct StudyRoomInputView: View {
    @Binding public var inputText: String
    public let onSendAction: () -> Void
    
    public init(inputText: Binding<String>, onSendAction: @escaping () -> Void) {
        self._inputText = inputText
        self.onSendAction = onSendAction
    }
    
    public var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            TextField("Ask your AI tutor", text: $inputText)
                .font(AppTheme.textStyle(size: 16))
                .foregroundColor(AppTheme.Colors.black100)
                .padding(AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                        .stroke(AppTheme.Colors.gray100, lineWidth: 1)
                )
            
            Button(action: onSendAction) {
                Image("send")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(AppTheme.Spacing.xSmall)
                    .background(Circle().foregroundColor(AppTheme.Colors.white100).appShadow(opacity: 0.7, radius: 2.5))
            }
            .disabled(inputText.isEmpty)
        }
        .padding(AppTheme.Spacing.small)
        .background(AppTheme.Colors.white100)
        .background(
            AppTheme.Colors.white100
                .appShadow(opacity: 0.20, radius: 3, y: -1)
                .ignoresSafeArea(edges: .top)
        )
    }
}
