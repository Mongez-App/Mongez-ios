//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct TeamCourseMaterialsTabView: View {
    public let materials: [TeamCourseMaterial]
    public let courseType: String
    public let isLoading: Bool
    public init(materials: [TeamCourseMaterial], courseType: String, isLoading: Bool = false) {
        self.materials = materials
        self.courseType = courseType
        self.isLoading = isLoading
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
                
            } else {
                ScrollView {
                    LazyVStack(spacing: AppTheme.Spacing.small) {
                        ForEach(materials) { material in
                            MaterialRowView(material: material)
                        }
                    }
                    .padding(AppTheme.Spacing.small)
                    .padding(.top, AppTheme.Spacing.xSmall)
                }
            }
        }
    }
}
