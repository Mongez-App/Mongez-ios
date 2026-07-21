//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct MaterialRowView: View {
    public let material: CourseMaterial
    
    public init(material: CourseMaterial) {
        self.material = material
    }
    
    public var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Text("PDF")
                .font(AppTheme.textStyle(size: 14, weight: .bold))
                .foregroundColor(AppTheme.Colors.white100)
                .frame(width: 48, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .fill(AppTheme.Colors.red100)
                )
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                Text(material.name)
                    .font(AppTheme.textStyle(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .lineLimit(1)
                
                Text("\(material.pageCount) Pages • \(String(format: "%.1f", material.fileSizeMB)) MB")
                    .font(AppTheme.textStyle(size: 14))
                    .foregroundColor(AppTheme.Colors.gray300)
            }
            Spacer(minLength: AppTheme.Spacing.small)
            
            Image(systemName: "ellipsis")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(AppTheme.Colors.black100)
        }
        .padding(AppTheme.Spacing.small)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .fill(AppTheme.Colors.white100)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                        .stroke(AppTheme.Colors.gray100, lineWidth: 1.5)
                )
        )
    }
}
