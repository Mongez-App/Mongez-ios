//
//  File.swift
//  
//
//  Created by Mazen Amr on 21/07/2026.
//

import Foundation
import SwiftUI
import Common
import PhotosUI

public struct EditCourseSheetView: View {
    @State private var courseName: String = ""
    @State private var selectedImageItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @Environment(\.dismiss) private var dismiss
    public var onSubmit: ((String, Data?) -> Void)?
    
    public init(initialCourseName: String = "", onSubmit: ((String, Data?) -> Void)? = nil) {
        self._courseName = State(initialValue: initialCourseName)
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
                HStack {
                    Spacer()
                    Capsule()
                        .fill(AppTheme.Colors.gray200)
                        .frame(width: 40, height: 4)
                    Spacer()
                }
                .padding(.top, AppTheme.Spacing.xSmall)
                
                Text("Edit Course")
                    .font(AppTheme.textStyle(size: 20, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                Text("Course Name")
                    .font(AppTheme.textStyle(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                TextField("e.g. Operating Systems", text: $courseName)
                    .font(AppTheme.textStyle(size: 14))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .fill(AppTheme.Colors.white100)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.radius.small)
                            .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                    )
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                Text("Thumbnail")
                    .font(AppTheme.textStyle(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                PhotosPicker(selection: $selectedImageItem, matching: .images, photoLibrary: .shared()) {
                    VStack(spacing: AppTheme.Spacing.small) {
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundColor(.green)
                            .padding()
                            .background(
                                Circle()
                                    .fill(AppTheme.Colors.white100)
                                    .appShadow(opacity: 0.1, radius: 4)
                            )
                        
                        VStack(spacing: 4) {
                            Text(selectedImageItem == nil ? "Upload cover image" : "Image selected")
                                .font(AppTheme.textStyle(size: 14, weight: .bold))
                                .foregroundColor(AppTheme.Colors.black100)
                            
                            Text("PNG or JPG, up to 5 MB")
                                .font(AppTheme.textStyle(size: 12))
                                .foregroundColor(AppTheme.Colors.gray300)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.xLarge)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                            .foregroundColor(AppTheme.Colors.gray200)
                    )
                }
                .buttonStyle(.plain)
                .onChange(of: selectedImageItem) { newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            }
            Spacer()
            
            Button(action: {
                onSubmit?(courseName, selectedImageData)
                dismiss()
            }) {
                Text("Save Changes")
                    .font(AppTheme.textStyle(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.white100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.medium)
                    .background(AppTheme.Colors.purple200)
                    .cornerRadius(AppTheme.radius.large)
                    .appShadow(opacity: 0.2, radius: 8, y: 4)
            }
            .disabled(courseName.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(courseName.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1.0)
            .padding(.bottom, AppTheme.Spacing.small)
            
        }
        .padding(.horizontal, AppTheme.Spacing.medium)
        .background(AppTheme.Colors.white100.ignoresSafeArea())
    }
}
