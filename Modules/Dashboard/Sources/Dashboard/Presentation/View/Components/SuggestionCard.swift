//
//  SwiftUIView.swift
//  
//
//  Created by Ahmed Tarek on 19/07/2026.
//

import SwiftUI
import Common

struct SuggestionCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("AI Suggestion")
                    .font(AppTheme.textStyle(size: 13, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.green100)
                    .padding(.bottom, AppTheme.Spacing.xxSmall)
                
                Text("You're most productive around 7 PM. Start Networking before Algorithms today.")
                    .font(AppTheme.textStyle(size: 10, weight: .regular))
                    .foregroundColor(AppTheme.Colors.black100)
                    .frame(maxWidth: 265, alignment: .leading)
                
            }
            
            Spacer()
            
            Image("sun")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(AppTheme.Colors.green100)
                .padding(AppTheme.Spacing.xSmall)
                .background(AppTheme.Colors.green100.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))
        }
        .padding(AppTheme.Spacing.small)
        .frame(height: 90)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.Colors.white100)
        .cornerRadius(AppTheme.radius.small)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .stroke(AppTheme.Colors.green100.opacity(0.4), lineWidth: 1)
        )
        
    }
}

struct SuggestionCard_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionCard()
    }
}
