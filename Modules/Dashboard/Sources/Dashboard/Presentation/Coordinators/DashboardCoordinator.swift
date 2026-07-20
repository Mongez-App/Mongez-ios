//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import Common
import SwiftUI

public final class DashboardCoordinator: ObservableObject, Coordinator {
    public let id = UUID()
    public var childCoordinators: [any Coordinator] = []
    
    @Published public var path = NavigationPath()
    
    public init() {}
    
    public func push(_ route: DashboardRoute) {
        path.append(route)
    }
}
