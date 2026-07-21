//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI

public struct AuthCoordinatorView: View {
    @ObservedObject var coordinator: AuthCoordinator
    @StateObject var viewModel: AuthViewModel
    
    public init(coordinator: AuthCoordinator, viewModel: AuthViewModel) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationStack(path: $coordinator.path) {
        AuthView(viewModel: viewModel)
            .onAppear {
                viewModel.onAuthSuccess = { [weak coordinator] isNewUser in
                    if isNewUser {
                        coordinator?.onRegisterSuccess?()
                    } else {
                        coordinator?.onLoginSuccess?()
                    }
                }
            }
        }
    }
}
