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
    public let onPauseAction: () -> Void
    public let onDoneAction: () -> Void
    
    public init(taskTitle: String, onPauseAction: @escaping () -> Void, onDoneAction: @escaping () -> Void) {
        self.taskTitle = taskTitle
        self.onPauseAction = onPauseAction
        self.onDoneAction = onDoneAction
    }
    
    public var body: some View {
        HStack {
            Text(taskTitle)
                .font(AppTheme.textStyle(size: 24, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
            
            Spacer()
            
            Button(action: onPauseAction) {
                Image("pause")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(AppTheme.Spacing.xSmall)
                    .background(Circle().foregroundColor(AppTheme.Colors.white100)).appShadow(opacity: 0.7, radius: 2.5)
            }
            
            Button(action: onDoneAction) {
                Image("done_green")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(AppTheme.Spacing.xSmall)
                    .background(Circle().foregroundColor(AppTheme.Colors.white100)).appShadow(opacity: 0.7, radius: 2.5)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.small)
        .padding(.top, AppTheme.Spacing.small)
    }
}
