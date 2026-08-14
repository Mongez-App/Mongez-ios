//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct CourseMaterialsTabView: View {
    public let materials: [CourseMaterial]
    public let courseType: String
    public let isLoading: Bool
    public let onUploadAction: () -> Void
    public var onDeleteMaterial: ((String) -> Void)?
    
    public init(materials: [CourseMaterial], courseType: String, isLoading: Bool = false, onUploadAction: @escaping () -> Void = {}, onDeleteMaterial: ((String) -> Void)? = nil) {
        self.materials = materials
        self.courseType = courseType
        self.isLoading = isLoading
        self.onUploadAction = onUploadAction
        self.onDeleteMaterial = onDeleteMaterial
    }
    
    public var body: some View {
        VStack {
            if courseType == "URL_COURSE" {
                if !isLoading {
                    VStack(spacing: AppTheme.Spacing.small) {
                        Spacer()
                        
                        Image("online-material")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .padding(.bottom, AppTheme.Spacing.small)
                        
                        Text("Study materials for online courses are managed externally.")
                            .font(AppTheme.textStyle(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.gray300)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppTheme.Spacing.large)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    Spacer()
                }
                
            } else if materials.isEmpty {
                if !isLoading {
                    VStack(spacing: AppTheme.Spacing.small) {
                        Spacer()
                        
                        Image("material")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .padding(.bottom, AppTheme.Spacing.small)
                        
                        Text("No materials have been uploaded yet.")
                            .font(AppTheme.textStyle(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.gray300)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppTheme.Spacing.large)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    Spacer()
                }
                
                UploadMaterialButtonView(action: onUploadAction)
                    .padding(AppTheme.Spacing.small)
                
            } else {
                ScrollView {
                    LazyVStack(spacing: AppTheme.Spacing.small) {
                        ForEach(materials) { material in
                            MaterialRowView(material: material) {
                                onDeleteMaterial?(material.id)
                            }
                        }
                    }
                    .padding(AppTheme.Spacing.small)
                    .padding(.top, AppTheme.Spacing.xSmall)
                }
                
                UploadMaterialButtonView(action: onUploadAction)
                    .padding(AppTheme.Spacing.small)
            }
        }
    }
}
