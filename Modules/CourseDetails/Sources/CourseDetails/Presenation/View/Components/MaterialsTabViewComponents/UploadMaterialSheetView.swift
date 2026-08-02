//
//  File.swift
//  
//
//  Created by Mazen Amr on 30/07/2026.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import Common

public struct UploadMaterialSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isDocumentPickerPresented = false

    @State private var selectedFileName: String? = nil
    @State private var selectedFileSizeString: String? = nil
    @State private var selectedFileData: Data? = nil
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
            
            HStack(spacing: AppTheme.Spacing.xxxSmall) {
                Text("Course Material")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                Text("(PDFs, slides, notes)")
                    .font(AppTheme.textStyle(size: 14, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray300)
            }
            .padding(.top, AppTheme.Spacing.large)
            
            Button(action: {
                isDocumentPickerPresented = true
            }) {
                VStack(spacing: AppTheme.Spacing.xSmall) {
                    Image(systemName: "plus")
                        .font(AppTheme.textStyle(size: 20, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple100)
                        .frame(width: 48, height: 48)
                        .background(AppTheme.Colors.white100)
                        .clipShape(Circle())
                        .appShadow(opacity: 0.1, radius: 4, y: 2)
                    
                    Text("Upload material")
                        .font(AppTheme.textStyle(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                    
                    Text("Tap to browse files")
                        .font(AppTheme.textStyle(size: 14, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray300)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.xxLarge)
                .background(AppTheme.Colors.white100)
                .cornerRadius(AppTheme.radius.meduim)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                        .stroke(
                            AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple100, opacity: 0.3),
                            style: StrokeStyle(lineWidth: 1.5, dash: [6, 4])
                        )
                )
            }
            
            if let name = selectedFileName, let sizeString = selectedFileSizeString {
                HStack(spacing: AppTheme.Spacing.small) {
                    Text("PDF")
                        .font(AppTheme.textStyle(size: 12, weight: .bold))
                        .foregroundColor(AppTheme.Colors.red100)
                        .padding(.horizontal, AppTheme.Spacing.xSmall)
                        .padding(.vertical, AppTheme.Spacing.xxSmall)
                        .background(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.red100, opacity: 0.1))
                        .cornerRadius(AppTheme.radius.small)
                    
                    Text(name)
                        .font(AppTheme.textStyle(size: 14, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(sizeString)
                        .font(AppTheme.textStyle(size: 12, weight: .regular))
                        .foregroundColor(AppTheme.Colors.gray300)
                }
                .padding(AppTheme.Spacing.small)
                .background(AppTheme.Colors.white100)
                .cornerRadius(AppTheme.radius.meduim)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                        .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                )
                .appShadow(opacity: 0.05, radius: 2, y: 1)
            }
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Text("Add Material")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.white100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.medium)
                    .background(AppTheme.Colors.purple100)
                    .cornerRadius(AppTheme.radius.large)
            }
            .disabled(selectedFileData == nil)
            .opacity(selectedFileData == nil ? 0.5 : 1.0)
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .fileImporter(
            isPresented: $isDocumentPickerPresented,
            allowedContentTypes: [UTType.pdf, UTType.presentation],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedUrl = try result.get().first else { return }
                
                if selectedUrl.startAccessingSecurityScopedResource() {
                    defer { selectedUrl.stopAccessingSecurityScopedResource() }
                    self.selectedFileName = selectedUrl.lastPathComponent
                    let resources = try selectedUrl.resourceValues(forKeys: [.fileSizeKey])
                    if let fileSize = resources.fileSize {
                        let sizeInMB = Double(fileSize) / (1024.0 * 1024.0)
                        self.selectedFileSizeString = String(format: "%.1f MB", sizeInMB)
                    } else {
                        self.selectedFileSizeString = "Unknown Size"
                    }
                
                    self.selectedFileData = try Data(contentsOf: selectedUrl)
                }
            } catch {
                print("Failed to read document: \(error.localizedDescription)")
            }
        }
    }
}
