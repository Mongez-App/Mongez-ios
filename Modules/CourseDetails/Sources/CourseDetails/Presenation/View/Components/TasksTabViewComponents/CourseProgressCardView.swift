//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct CourseProgressCardView: View {
    public let progressPercentage: Double
    public let completedTasksCount: Int
    public let totalTasksCount: Int
    
    public init(progressPercentage: Double, completedTasksCount: Int, totalTasksCount: Int) {
        self.progressPercentage = progressPercentage
        self.completedTasksCount = completedTasksCount
        self.totalTasksCount = totalTasksCount
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                    Text("Course Progress")
                        .font(AppTheme.textStyle(size: 14, weight: .regular))
                        .foregroundColor(AppTheme.Colors.white100)
                    
                    Text("\(completedTasksCount) of \(totalTasksCount) tasks done")
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.white100)
                }
                
                Spacer()
                
                Text("\(Int(progressPercentage * 100))%")
                    .font(AppTheme.textStyle(size: 12, weight: .regular))
                    .foregroundColor(AppTheme.Colors.white100)
                    .padding(.horizontal, AppTheme.Spacing.small)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(AppTheme.Colors.white100.opacity(0.2)))
            }
            .padding(.bottom, AppTheme.Spacing.xxSmall)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppTheme.Colors.white100.opacity(0.3))
                        .frame(height: 6)
                    
                    Capsule()
                        .fill(AppTheme.Colors.white100)
                        .frame(width: max(0, geometry.size.width * CGFloat(progressPercentage)), height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding(AppTheme.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.large)
                .fill(AppTheme.Colors.purple200)
                .appShadow(opacity: 0.25, radius: 20, y: 10)
        )
        .padding(.horizontal, AppTheme.Spacing.small)
        .padding(.top, AppTheme.Spacing.xSmall)
    }
}
