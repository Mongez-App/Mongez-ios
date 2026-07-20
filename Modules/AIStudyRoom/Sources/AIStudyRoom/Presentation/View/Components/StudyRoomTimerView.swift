//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct StudyRoomTimerView: View {
    
    public init() {}
    
    public var body: some View {
        HStack(spacing: AppTheme.Spacing.xxSmall) {
            HStack(spacing: AppTheme.Spacing.xxxSmall) {
                Image("clock")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text("00:00")
                    .font(AppTheme.textStyle(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
            }
            .padding(.horizontal, AppTheme.Spacing.xSmall)
            .padding(.vertical, AppTheme.Spacing.xxxSmall)
            .background(Capsule().stroke(AppTheme.Colors.gray100, lineWidth: 1))
            
            Text("/")
                .font(AppTheme.textStyle(size: 14, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
            
            HStack(spacing: AppTheme.Spacing.xxxSmall) {
                Image("clock")
                    .resizable()
                    .frame(width: 14, height: 14)
                Text("25:00")
                    .font(AppTheme.textStyle(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
            }
            .padding(.horizontal, AppTheme.Spacing.xSmall)
            .padding(.vertical, AppTheme.Spacing.xxxSmall)
            .background(Capsule().stroke(AppTheme.Colors.gray100, lineWidth: 1))
            
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.small)
        .padding(.top, AppTheme.Spacing.xSmall)
        .padding(.bottom, AppTheme.Spacing.small)
    }
}
