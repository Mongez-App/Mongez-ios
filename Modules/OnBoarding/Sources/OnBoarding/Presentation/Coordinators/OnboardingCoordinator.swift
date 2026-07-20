//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import Observation
import Common

public final class OnboardingCoordinator: ObservableObject, Coordinator {
    public let id = UUID()
    public var childCoordinators: [any Coordinator] = []

    public var onFinish: (() -> Void)?
    
    public init() {}
}
