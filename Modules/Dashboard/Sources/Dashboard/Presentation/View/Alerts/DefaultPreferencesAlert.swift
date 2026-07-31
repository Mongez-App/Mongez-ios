//
//  SwiftUIView.swift
//
//
//  Created by Ahmed Tarek on 31/07/2026.
//

import SwiftUI
import Common

public struct DefaultPreferencesAlert: View {
    @Binding var isPresented: Bool
    
    let gotItAction: () -> Void
    let settingsAction: () -> Void
    
    public var body: some View {
        VStack(spacing: AppTheme.Spacing.xLarge) {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.purple200.opacity(0.16))
                    .frame(width: 56, height: 56)
                
                Image("calendar-time")
                    .renderingMode(.template)
                    .frame(width: 32, height: 32)
                    .foregroundColor(AppTheme.Colors.purple200)
            }
            
            Text("Your schedule is set to\ndefault")
                .font(AppTheme.textStyle(size: 20, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                
                HStack(alignment: .top, spacing: AppTheme.Spacing.medium) {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppTheme.Colors.gray100, lineWidth: 1)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image("clock-white")
                                .renderingMode(.template)
                                .frame(width: 13, height: 13)
                                .foregroundColor(AppTheme.Colors.black100)
                        )
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                        Text("Study Time")
                            .font(AppTheme.textStyle(size: 12, weight: .regular))
                            .foregroundColor(AppTheme.Colors.gray300)
                        
                        Text("5 hours / day")
                            .font(AppTheme.textStyle(size: 14, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.black100)
                    }
                }
                
                // Row 2: Study Days
                HStack(alignment: .top, spacing: AppTheme.Spacing.medium) {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppTheme.Colors.gray100, lineWidth: 1)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image("calendar-red")
                                .renderingMode(.template)
                                .frame(width: 13, height: 13)
                                .foregroundColor(AppTheme.Colors.black100)
                        )
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                        Text("Study Days")
                            .font(AppTheme.textStyle(size: 12, weight: .regular))
                            .foregroundColor(AppTheme.Colors.gray300)
                        
                        // Days layout (split into two HStacks to mimic wrapping)
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                DayPillView(day: "Sun")
                                DayPillView(day: "Mon")
                                DayPillView(day: "Tue")
                                DayPillView(day: "Wed")
                            }
                            HStack(spacing: 6) {
                                DayPillView(day: "Thu")
                            }
                        }
                    }
                    
                    
                }
            }
            .padding(.horizontal, AppTheme.Spacing.xSmall)
            .padding(.vertical, AppTheme.Spacing.xSmall)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                    .stroke(AppTheme.Colors.gray100, lineWidth: 1)
            )
            
            VStack(spacing: AppTheme.Spacing.xSmall) {
                Button {
                    gotItAction()
                    withAnimation { isPresented = false }
                } label: {
                    Text("Got It")
                        .font(AppTheme.textStyle(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.Colors.white100)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(AppTheme.Colors.purple200) // Replace with AppTheme
                        .cornerRadius(AppTheme.radius.small)
                }
                
                Button {
                    settingsAction()
                    withAnimation { isPresented = false }
                } label: {
                    Text("Go to Settings")
                        .font(AppTheme.textStyle(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.Colors.black100)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(AppTheme.Colors.white100)
                        .cornerRadius(AppTheme.radius.small)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                .stroke(AppTheme.Colors.gray100, lineWidth: 1)
                        )
                }
            }
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.vertical, AppTheme.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .fill(AppTheme.Colors.white100)
                .appShadow(opacity: 0.5, radius: 25/2, y: 0)
        )
        .padding(.horizontal, AppTheme.Spacing.large)
    }
}

struct DayPillView: View {
    let day: String
    
    var body: some View {
        Text(day)
            .font(AppTheme.textStyle(size: 10, weight: .medium))
            .foregroundColor(AppTheme.Colors.black100)
            .padding(.horizontal, AppTheme.Spacing.xxSmall)
            .padding(.vertical, AppTheme.Spacing.xxxSmall)
            .background(AppTheme.Colors.gray100.opacity(0.5))
            .cornerRadius(AppTheme.radius.small)
    }
}

//#Preview {
//    DefaultPreferencesAlert()
//}
