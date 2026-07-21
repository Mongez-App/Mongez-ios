//
//  PreferencesCoordinator.swift
//
//
//  Created by Ahmed Mohamed Fathi on 21/07/2026.
//

import Foundation
import Common

public final class PreferencesCoordinator: ObservableObject, Coordinator {
    public let id = UUID()
    public var childCoordinators: [any Coordinator] = []

    public var onFinish: (() -> Void)?

    public init() {}
}
