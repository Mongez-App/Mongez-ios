//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct CourseHeaderView: View {
    public let title: String
    public let onBack: () -> Void
    public let onEdit: () -> Void
    public let onDelete: () -> Void
    
    public init(title: String, onBack: @escaping () -> Void = {}, onEdit: @escaping () -> Void = {}, onDelete: @escaping () -> Void = {}) {
        self.title = title
        self.onBack = onBack
        self.onEdit = onEdit
        self.onDelete = onDelete
    }
    
    public var body: some View {
        HStack(alignment: .center, spacing: AppTheme.Spacing.small) {
            Button(action: onBack) {
                Image("back")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
            }
            .padding(.trailing, 2)
            
            Text(title)
                .font(AppTheme.textStyle(size: 24, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
                .lineLimit(1)
            
            Spacer()
            
            Menu {
                Button(action: onEdit) {
                    Label("Edit Course", systemImage: "pencil")
                }
                
                Button(role: .destructive, action: onDelete) {
                    Label("Delete Course", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .frame(width: 44, height: 44, alignment: .trailing)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.small)
        .padding(.vertical, AppTheme.Spacing.small)
    }
}
