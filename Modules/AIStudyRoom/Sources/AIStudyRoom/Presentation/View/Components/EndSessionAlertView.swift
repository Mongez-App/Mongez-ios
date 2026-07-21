//
//  File.swift
//  
//
//  Created by Mazen Amr on 21/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct EndSessionAlertView: View {
    public let onEndSession: () -> Void
    public let onKeepStudying: () -> Void
    
    public init(onEndSession: @escaping () -> Void, onKeepStudying: @escaping () -> Void) {
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
                        .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.green100, opacity: 0.15))
                        .frame(width: 64, height: 64)
                    
                    Image("done_green")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                .padding(.top, AppTheme.Spacing.small)
                
                VStack(spacing: AppTheme.Spacing.xxSmall) {
                    Text("End this session?")
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                    
                    Text("Your progress will be saved and this\ntask will be marked as complete.")
                        .font(AppTheme.textStyle(size: 14, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray300)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.Spacing.small)
                }
                
                VStack(spacing: AppTheme.Spacing.small) {
                    Button(action: onEndSession) {
                        Text("End session")
                            .font(AppTheme.textStyle(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.white100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .fill(AppTheme.Colors.purple200)
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
