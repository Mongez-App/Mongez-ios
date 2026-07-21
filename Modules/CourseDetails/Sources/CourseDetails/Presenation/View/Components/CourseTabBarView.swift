//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct CourseTabBarView: View {
    @Binding public var selectedTab: Int
    @Namespace private var animation
    
    public init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }
    
    public var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            tabItem(title: "Materials", tabIndex: 0)
            tabItem(title: "Tasks", tabIndex: 1)
        }
        .padding(.top, AppTheme.Spacing.small)
        .padding(.horizontal, AppTheme.Spacing.small)
        .overlay(
            Rectangle()
                .fill(AppTheme.Colors.gray200)
                .frame(height: 1)
                .padding(.horizontal, AppTheme.Spacing.small),
            alignment: .bottom
        )
    }
    
    private func tabItem(title: String, tabIndex: Int) -> some View {
        let isSelected = selectedTab == tabIndex
        
        return VStack(spacing: AppTheme.Spacing.xSmall) {
            Text(title)
                .font(AppTheme.textStyle(
                    size: isSelected ? 20 : 16,
                    weight: isSelected ? .bold : .medium
                ))
                .foregroundColor(isSelected ? AppTheme.Colors.purple200 : AppTheme.Colors.gray300)
                .frame(maxWidth: .infinity)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
            
            ZStack {
                if isSelected {
                    Rectangle()
                        .fill(AppTheme.Colors.purple200)
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "TabUnderline", in: animation)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 2)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selectedTab = tabIndex
            }
        }
    }
}
