//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 27/07/2026.
//

import SwiftUI
import Common

public struct CustomAlertView: View {
    @Binding var isPresented: Bool
    
    let title: String
    let description: String
    
    var primaryButtonTitle: String = "Cancel"
    let secondaryButtonTitle: String
    
    let secondaryAction: () -> Void
    
    public var body: some View {
        VStack {
    
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.red100.opacity(0.15))
                    .frame(width: 56, height: 56)
                
                Image("warning")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(AppTheme.Colors.red100)
            }
            .padding(.bottom, AppTheme.Spacing.xxLarge)
            
            VStack(spacing: AppTheme.Spacing.xSmall) {
                Text(title)
                    .font(AppTheme.textStyle(size: 18, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.blue100)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(AppTheme.textStyle(size: 14, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, AppTheme.Spacing.xLarge)
            
            HStack(spacing: AppTheme.Spacing.small) {
                Button {
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    Text(primaryButtonTitle)
                        .font(AppTheme.textStyle(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.Colors.black100)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(AppTheme.Colors.purple200)
                        .cornerRadius(AppTheme.radius.small)
                }
                
                Button {
                    secondaryAction()
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    Text(secondaryButtonTitle)
                        .font(AppTheme.textStyle(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 42)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                .fill(AppTheme.Colors.white100)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                .stroke(AppTheme.Colors.gray100, lineWidth: 1)
                        )
                }
            }
        }
        .padding(.vertical, AppTheme.Spacing.large)
        .padding(.horizontal, AppTheme.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .fill(Color.white)
                .appShadow(opacity: 0.7, radius: 25/2)
        )
        .padding(.horizontal, AppTheme.Spacing.large)
    }
}
