//
//  SwiftUIView.swift
//
//
//  Created by Ahmed Tarek on 20/07/2026.
//

import SwiftUI
import Common

struct TodayFocusCard: View {
    @Binding var todayFocus: TodayFocus?
    
    var imageUrl: String = ""
    
    var body: some View {
        HStack() {
            AsyncImage(url: URL(string: imageUrl)) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 160, height: 160)
                        .overlay(Image(systemName: "photo").foregroundColor(.white))
                        //.overlay(ProgressView())
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.meduim))
                case .failure:
                    RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                        .fill(AppTheme.Colors.white100.opacity(0.2))
                        .frame(width: 160, height: 160)
                        .overlay(Image(systemName: "photo").foregroundColor(AppTheme.Colors.white100))
                @unknown default:
                    EmptyView()
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Today's Focus")
                    .font(AppTheme.textStyle(size: 13, weight: .medium))
                    .foregroundColor(AppTheme.Colors.white100)
                    .padding(.bottom, 2)
                
                Text("\(todayFocus!.courseName ?? "")")
                    .font(AppTheme.textStyle(size: 20, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.white100)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    
                Spacer()
 
                HStack(spacing: AppTheme.Spacing.xxSmall) {
                    Image("clock-white")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    
                    Text(todayFocus!.allocatedDuration)
                        .font(AppTheme.textStyle(size: 13, weight: .regular))
                }
                .foregroundColor(AppTheme.Colors.white100)
                .padding(.horizontal, AppTheme.Spacing.xxSmall)
                .padding(.vertical, AppTheme.Spacing.xxSmall)
                .background(AppTheme.Colors.white100.opacity(0.18))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))
                .padding(.bottom, AppTheme.Spacing.xxSmall)
                
                
                Button(action: {
                    print("Let's Start is pressed")
                }) {
                    Text("Let's Start")
                        .font(AppTheme.textStyle(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.purple200)
                        .frame(width: 120, height: 36)
                        .background(AppTheme.Colors.white100)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.xxxSmall)
            
        }
        .padding(AppTheme.Spacing.small)
        .frame(maxWidth: .infinity)
        .frame(height: 184)
        .background(AppTheme.Colors.purple200)
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.large))
        .appShadow(opacity: 0.5, radius: 15/2)
    }
    
}

//#Preview {
//    TodayFocusCard()
//}
