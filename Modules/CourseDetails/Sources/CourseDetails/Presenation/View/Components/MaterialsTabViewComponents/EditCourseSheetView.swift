//
//  File.swift
//  
//
//  Created by Mazen Amr on 21/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct EditCourseSheetView: View {
    @State private var courseName: String = ""
    @State private var deadline: Date = Date()
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.large) {
            
            HStack {
                Spacer()
                Capsule()
                    .fill(AppTheme.Colors.gray200)
                    .frame(width: 40, height: 4)
                Spacer()
            }
            .padding(.top, AppTheme.Spacing.xSmall)
            
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
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                Text("Deadline")
                    .font(AppTheme.textStyle(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                HStack {
                    Text(deadline, format: .dateTime.day().month(.twoDigits).year())
                        .font(AppTheme.textStyle(size: 14))
                        .foregroundColor(AppTheme.Colors.purple200)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .foregroundColor(AppTheme.Colors.black100)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppTheme.Colors.white100)
                                .appShadow(opacity: 0.1, radius: 4)
                        )
                        .overlay {
                            DatePicker("", selection: $deadline, displayedComponents: .date)
                                .labelsHidden()
                                .blendMode(.destinationOver)
                        }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .fill(AppTheme.Colors.white100)
                )
            }
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                Text("Thumbnail")
                    .font(AppTheme.textStyle(size: 14, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                
                Button(action: {}) {
                    VStack(spacing: AppTheme.Spacing.small) {
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundColor(AppTheme.Colors.yellow100)
                            .padding()
                            .background(Circle().fill(AppTheme.Colors.white100).appShadow(opacity: 0.1, radius: 4))
                        
                        VStack(spacing: 4) {
                            Text("Upload cover image")
                                .font(AppTheme.textStyle(size: 14, weight: .bold))
                                .foregroundColor(AppTheme.Colors.black100)
                            
                            Text("PNG or JPG, up to 5 MB")
                                .font(AppTheme.textStyle(size: 12))
                                .foregroundColor(AppTheme.Colors.gray200)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.xLarge)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                            .foregroundColor(AppTheme.Colors.purple200.opacity(0.3))
                    )
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, AppTheme.Spacing.medium)
        .background(AppTheme.Colors.white100.ignoresSafeArea())
    }
}
