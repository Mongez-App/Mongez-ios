//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI

public struct OnboardingCoordinatorView: View {
    @ObservedObject var coordinator: OnboardingCoordinator
    @StateObject var viewModel: OnboardingViewModel
    
    public init(coordinator: OnboardingCoordinator, viewModel: OnboardingViewModel) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        OnBoardingView(viewModel: viewModel)
            .onAppear {
                viewModel.onFinishOnboarding = { [weak coordinator] in
                    coordinator?.onFinish?()
                }
            }
    }
}
