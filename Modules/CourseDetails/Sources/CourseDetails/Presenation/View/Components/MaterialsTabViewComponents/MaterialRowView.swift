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
    public var onDelete: (() -> Void)?
    
    @State private var isPreviewPresented = false
    
    public init(material: CourseMaterial, onDelete: (() -> Void)? = nil) {
        self.material = material
        self.onDelete = onDelete
    }
    
    public var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Button(action: {
                if material.materialPath != nil {
                    isPreviewPresented = true
                }
            }) {
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
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
            Menu {
                Button(role: .destructive, action: {
                    onDelete?()
                }) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(AppTheme.Colors.black100)
                    .frame(width: 44, height: 44, alignment: .trailing)
                    .contentShape(Rectangle())
            }
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
        .fullScreenCover(isPresented: $isPreviewPresented) {
            if let path = material.materialPath, let url = URL(string: path) {
                NavigationView {
                    WebView(url: url)
                        .navigationTitle(material.name)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    isPreviewPresented = false
                                }
                            }
                        }
                }
            }
        }
    }
}
