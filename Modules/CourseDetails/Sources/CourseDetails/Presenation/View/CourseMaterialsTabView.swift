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
    public let onUploadAction: () -> Void
    public let onDeleteAction: (CourseMaterial) -> Void

    public init(
        materials: [CourseMaterial],
        onUploadAction: @escaping () -> Void = {},
        onDeleteAction: @escaping (CourseMaterial) -> Void = { _ in }
    ) {
        self.materials = materials
        self.onUploadAction = onUploadAction
        self.onDeleteAction = onDeleteAction
    }

    public var body: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: AppTheme.Spacing.small) {
                    ForEach(materials) { material in
                        MaterialRowView(material: material, onDelete: onDeleteAction)
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