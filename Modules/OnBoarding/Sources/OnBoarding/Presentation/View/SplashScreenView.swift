//
//  SplashScreenView.swift
//  OnBoarding
//
//  Created by Shady Eldakrory on 27/07/2026.
//

import SwiftUI
import Common

public struct SplashScreenView: View {
    let logoImageName: String
    let sloganImageName: String
    let onSplashFinished: () -> Void

    @State private var logoScale: CGFloat = 0.5
    @State private var logoRotation: Double = 0
    @State private var sloganOpacity: Double = 0

    public init(logoImageName: String, sloganImageName: String, onSplashFinished: @escaping () -> Void) {
        self.logoImageName = logoImageName
        self.sloganImageName = sloganImageName
        self.onSplashFinished = onSplashFinished
    }

    public var body: some View {
        VStack(spacing: AppTheme.Spacing.xLarge) {
            Image(logoImageName)
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .scaleEffect(logoScale)
                .rotationEffect(.degrees(logoRotation))
                .shadow(color: AppTheme.Colors.purple200.opacity(0.4), radius: 20, x: 0, y: 10)

            Image(sloganImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .padding(.horizontal, AppTheme.Spacing.xLarge)
                .opacity(sloganOpacity)
                .offset(y: sloganOpacity == 0 ? 20 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .onAppear {
            withAnimation(.interpolatingSpring(stiffness: 170, damping: 12)) {
                logoScale = 1.0
                logoRotation = 360
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.6)) {
                sloganOpacity = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.3)) {
                    logoScale = 1.1
                    sloganOpacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onSplashFinished()
                }
            }
        }
    }
}
