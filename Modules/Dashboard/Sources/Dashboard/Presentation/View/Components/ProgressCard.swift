//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 19/07/2026.
//

import SwiftUI
import Common

struct ProgressCard: View {
    let color: Color
    let title: String
    let numerator: Int
    let denominator: Int
    let unit: String
    
    private var progressRatio: CGFloat {
        guard denominator > 0 else { return 0 }
        return CGFloat(numerator) / CGFloat(denominator)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xSmall) {
            Text(title)
                .font(AppTheme.textStyle(size: 12, weight: .medium))
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                HStack(alignment: .firstTextBaseline, spacing: AppTheme.Spacing
                    .xxxSmall) {
                    Text("\(numerator)")
                        .font(AppTheme.textStyle(size: 15, weight: .semibold))
                        .foregroundColor(color)
                    
                    Text("/")
                        .font(AppTheme.textStyle(size: 15, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.black100)
                    
                    Text("\(denominator)")
                        .font(AppTheme.textStyle(size: 15, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.black100)
                    
                    Text(unit)
                        .font(AppTheme.textStyle(size: 12, weight: .medium))
                        .foregroundColor(AppTheme.Colors.black100)
                        .padding(.leading, AppTheme.Spacing.xxxSmall)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(AppTheme.Colors.gray100.opacity(0.6))
                            .frame(height: 6)
                        
                        Capsule()
                            .fill(color)
                            .frame(width: geo.size.width * min(max(progressRatio, 0), 1), height: 6)
                    }
                }
                .frame(height: 8)
            }

        }
        .padding(AppTheme.Spacing.xSmall)
        .frame(width: 140, height: 85, alignment: .leading)
        .background(AppTheme.Colors.white100)
        .cornerRadius(AppTheme.radius.small)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .stroke(color.opacity(0.4), lineWidth: 1)
        )
    }
}


#Preview {
    ProgressCard(color:AppTheme.Colors.blue100,
               title: "Today's Goal",
               numerator: 4,
               denominator: 7,
               unit: "Tasks")
}
