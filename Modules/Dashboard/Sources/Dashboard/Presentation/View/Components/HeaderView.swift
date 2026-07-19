//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 19/07/2026.
//

import SwiftUI
import Foundation
import Common

struct HeaderView: View {
    //@Binding Var user: User
    
    var user = User.getMockUser()
    
    var body: some View {
        HStack {
            CircledAsyncImage(urlString: user.avatarUrl, name: user.name)
                .padding(.trailing, AppTheme.Spacing.xSmall)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                Text("Hi, \(user.name)")
                    .font(AppTheme.textStyle(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.Colors.black100)
                
                Text("Let's hit today's tasks")
                    .font(AppTheme.textStyle(size: 13, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
            }
            .frame(maxWidth: 187, alignment: .leading)
            
            Spacer()
            
            HStack {
                VStack {
                    HStack(spacing: AppTheme.Spacing.xxxSmall){
                        Text("\(user.streakCount)")
                            .font(AppTheme.textStyle(size: 13, weight: .bold))
                            .foregroundColor(AppTheme.Colors.orange100)
                        
                        Text("Day")
                            .font(AppTheme.textStyle(size: 13, weight: .bold))
                            .foregroundColor(AppTheme.Colors.black100)
                    }
                    
                    Text("Streak")
                        .font(AppTheme.textStyle(size: 13, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                }
                
                Image("Flame", bundle: .main)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)

            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 60)
        .padding(.bottom, 12)
        .frame(maxWidth: .infinity)
        .frame(maxWidth: .infinity)
        .background(
            AppTheme.Colors.white100
                .appShadow(opacity: 0.20, radius: 3, y: 1)
        )
        .ignoresSafeArea(edges: .top)
        
        Spacer()
        
    }
}

struct CircledAsyncImage: View {
    let urlString: String
    var size: CGFloat = 56
    var name: String
    
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.purple200.opacity(0.2))
                        .frame(width: 56, height: 56)
                        .appShadow(opacity: 0.7, radius: 0)
                    
                    Text(name.prefix(2).capitalized)
                        .font(AppTheme.textStyle(size: 20, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple200.opacity(0.8))
                }
                
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .appShadow(opacity: 0.75, radius: 5)
                
            case .failure:
                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.purple200.opacity(0.2))
                        .frame(width: 56, height: 56)
                        .appShadow(opacity: 0.7, radius: 5)
                    
                    Text(name.prefix(2).capitalized)
                        .font(AppTheme.textStyle(size: 20, weight: .medium))
                        .foregroundColor(AppTheme.Colors.purple200.opacity(0.8))
                }
                
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    HeaderView()
}
