//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public final class AuthCoordinator: ObservableObject, Coordinator {
    public let id = UUID()
    public var childCoordinators: [any Coordinator] = []

    @Published public var path = NavigationPath()
    public var onLoginSuccess: (() -> Void)?
    public var onRegisterSuccess: (() -> Void)?
    
    public init() {}
}
