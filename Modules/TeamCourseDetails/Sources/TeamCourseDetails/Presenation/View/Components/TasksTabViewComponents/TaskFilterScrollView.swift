//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct TaskFilterScrollView: View {
    public let filters: [String]
    public let selectedFilter: String
    public let onFilterSelected: (String) -> Void
    
    public init(filters: [String], selectedFilter: String, onFilterSelected: @escaping (String) -> Void) {
        self.filters = filters
        self.selectedFilter = selectedFilter
        self.onFilterSelected = onFilterSelected
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.small) {
                ForEach(filters, id: \.self) { filter in
                    let isSelected = filter == selectedFilter
                    Text(filter)
                        .font(AppTheme.textStyle(size: 14, weight: isSelected ? .bold : .medium))
                        .foregroundColor(isSelected ? AppTheme.Colors.white100 : AppTheme.Colors.gray300)
                        .padding(.horizontal, AppTheme.Spacing.small)
                        .padding(.vertical, AppTheme.Spacing.xxSmall)
                        .background(
                            Capsule()
                                .fill(isSelected ? AppTheme.Colors.purple200 : AppTheme.Colors.white100)
                                .overlay(
                                    Capsule()
                                        .stroke(isSelected ? Color.clear : AppTheme.Colors.gray200, lineWidth: 1)
                                )
                        )
                        .onTapGesture {
                            onFilterSelected(filter)
                        }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.small)
            .padding(.vertical, AppTheme.Spacing.xSmall)
        }
    }
}
