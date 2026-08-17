//
//  File.swift
//  
//
//  Created by Mazen Amr on 21/07/2026.
//

import Foundation
import SwiftUI
import Common

public enum EndSessionAlertType {
    case complete
    case incomplete
}

public struct EndSessionAlertView: View {
    public let type: EndSessionAlertType
    public let onEndSession: () -> Void
    public let onKeepStudying: () -> Void
    
    public init(type: EndSessionAlertType, onEndSession: @escaping () -> Void, onKeepStudying: @escaping () -> Void) {
        self.type = type
        self.onEndSession = onEndSession
        self.onKeepStudying = onKeepStudying
    }
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.large) {
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.changeOpacity(color: type == .complete ? AppTheme.Colors.green100 : AppTheme.Colors.red100, opacity: 0.15))
                        .frame(width: 64, height: 64)
                    
                    Image(type == .complete ? "done_green" : "warning")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .padding(.top, AppTheme.Spacing.small)
                
                VStack(spacing: AppTheme.Spacing.xxSmall) {
                    Text(type == .complete ? "End this session?" : "Pause this session?")
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                    
                    Text(type == .complete ? "Your progress will be saved and this\ntask will be marked as complete." : "Your progress will be saved but this\ntask will NOT be marked as complete.")
                        .font(AppTheme.textStyle(size: 14, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray300)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.Spacing.small)
                }
                
                VStack(spacing: AppTheme.Spacing.small) {
                    Button(action: onEndSession) {
                        Text(type == .complete ? "End session" : "Pause session")
                            .font(AppTheme.textStyle(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.white100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .fill(type == .complete ? AppTheme.Colors.purple200 : AppTheme.Colors.red100)
                            )
                    }
                    
                    Button(action: onKeepStudying) {
                        Text("Keep Studying")
                            .font(AppTheme.textStyle(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.black100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(AppTheme.Spacing.large)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.large)
                    .fill(AppTheme.Colors.white100)
                    .appShadow(opacity: 0.7, radius: 12.5)
            )
            .padding(.horizontal, AppTheme.Spacing.xLarge)
        }
    }
}
