//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 01/08/2026.
//

import SwiftUI
import Common

public struct ValidationAlert: View {
    @Binding var isPresented: Bool
    let title: LocalizedStringKey
    let description: String
    
    public var body: some View {
        VStack(spacing: AppTheme.Spacing.xLarge) {
            
            VStack(spacing: AppTheme.Spacing.large) {
                Text(title)
                    .font(AppTheme.textStyle(size: 20, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(AppTheme.textStyle(size: 14, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray300)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Button {
                withAnimation {
                    isPresented = false
                }
            } label: {
                Text("OK")
                    .font(AppTheme.textStyle(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.Colors.white100)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppTheme.Colors.purple200)
                    .cornerRadius(AppTheme.radius.small)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.vertical, AppTheme.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .fill(AppTheme.Colors.white100)
                .appShadow(opacity: 0.7, radius: 25/2)
        )
        .padding(.horizontal, AppTheme.Spacing.large)
    }
}

//#Preview {
//    ValidationAlert(title: "Validation", description: "This field must be filled")
//}
