//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct StudyRoomHeaderView: View {
    public let taskTitle: String
    @Binding public var isPaused: Bool
    public let onTogglePause: () -> Void
    public let onDoneAction: () -> Void
    public let onBackAction: () -> Void
    
    public init(
        taskTitle: String,
        isPaused: Binding<Bool>,
        onTogglePause: @escaping () -> Void,
        onDoneAction: @escaping () -> Void,
        onBackAction: @escaping () -> Void
    ) {
        self.taskTitle = taskTitle
        self._isPaused = isPaused
        self.onTogglePause = onTogglePause
        self.onDoneAction = onDoneAction
        self.onBackAction = onBackAction
    }
    
    public var body: some View {
        HStack {
            Button(action: onBackAction) {
                Image("back")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
            }
            .padding(.trailing, 2)
            
            Text(taskTitle)
                .font(AppTheme.textStyle(size: 20, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: 200, alignment: .leading)
            
            Spacer()

            Button(action: {
                isPaused.toggle()
                onTogglePause()
            }) {
                Image(isPaused ? "resume" : "pause")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(AppTheme.Spacing.xSmall)
                    .background(Circle().foregroundColor(AppTheme.Colors.white100).appShadow(opacity: 0.7, radius: 2.5))
            }

            Button(action: onDoneAction) {
                Image("done_green")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(AppTheme.Spacing.xSmall)
                    .background(Circle().foregroundColor(AppTheme.Colors.white100).appShadow(opacity: 0.7, radius: 2.5))
            }
        }
        .padding(.horizontal, AppTheme.Spacing.small)
        .padding(.top, AppTheme.Spacing.small)
    }
}
