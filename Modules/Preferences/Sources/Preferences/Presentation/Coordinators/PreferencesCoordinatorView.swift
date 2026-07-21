//
//  PreferencesCoordinatorView.swift
//
//
//  Created by Ahmed Mohamed Fathi on 21/07/2026.
//

import Foundation
import SwiftUI

public struct PreferencesCoordinatorView: View {
    @ObservedObject var coordinator: PreferencesCoordinator
    @StateObject var viewModel: PreferencesViewModel

    public init(coordinator: PreferencesCoordinator, viewModel: PreferencesViewModel) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        PreferencesView(viewModel: viewModel)
            .onAppear {
                viewModel.onFinish = { [weak coordinator] in
                    coordinator?.onFinish?()
                }
            }
    }
}
