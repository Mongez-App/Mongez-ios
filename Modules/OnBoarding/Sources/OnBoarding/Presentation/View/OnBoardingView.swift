//
//  SwiftUIView.swift
//  
//
//  Created by Shady Eldakrory on 17/07/2026.
//

import SwiftUI
import Common

public struct OnBoardingView: View {
    @ObservedObject public var viewModel: OnboardingViewModel
        
    public init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    viewModel.skip()
                }) {
                    Text("Skip")
                        .font(AppTheme.textStyle(size: 18, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.purple200)
                }
                .padding(.trailing, AppTheme.Spacing.large)
                .padding(.top, AppTheme.Spacing.medium)
            }
            
            TabView(selection: $viewModel.currentPage) {
                ForEach(0..<viewModel.steps.count, id: \.self) { index in
                    OnboardingPageView(step: viewModel.steps[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack(spacing: AppTheme.Spacing.small) {
                ForEach(0..<viewModel.steps.count, id: \.self) { index in
                    Capsule()
                        .fill(viewModel.currentPage == index ? AppTheme.Colors.purple200 : AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.3))
                        .frame(width: viewModel.currentPage == index ? 24 : 10, height: 10)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.currentPage)
                }
            }
            .padding(.vertical, AppTheme.Spacing.large)
            
            HStack {
                if viewModel.currentPage > 0 {
                    Button(action: {
                        withAnimation {
                            viewModel.previousPage()
                        }
                    }) {
                        Text("Previous")
                            .font(AppTheme.textStyle(size: 18, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.black100)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                            )
                    }
                    
                    Spacer(minLength: AppTheme.Spacing.medium)
                }
                
                Button(action: {
                    withAnimation {
                        viewModel.nextPage()
                    }
                }) {
                    Text(viewModel.isLastPage ? "Get Started" : "Next")
                        .font(AppTheme.textStyle(size: 18, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.white100)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.purple200)
                        .cornerRadius(AppTheme.radius.small)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.large)
            .padding(.bottom, AppTheme.Spacing.xLarge)
            .animation(.easeInOut, value: viewModel.currentPage)
        }
        .background(AppTheme.Colors.white100.ignoresSafeArea())
    }
}

struct OnboardingPageView: View {
    let step: OnboardingStep
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Spacer()
            
            Image(step.image)
                .resizable()
                .scaledToFit()
                .frame( height: 250)
                .padding(.horizontal, AppTheme.Spacing.large)
            
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.small) {
                Text(step.title)
                    .font(AppTheme.textStyle(size: 24, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .multilineTextAlignment(.center)
                
                Text(step.descreption)
                    .font(AppTheme.textStyle(size: 18, weight: .regular))
                    .foregroundColor(AppTheme.Colors.gray200)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.large)
            }
            Spacer()
        }
    }
}
