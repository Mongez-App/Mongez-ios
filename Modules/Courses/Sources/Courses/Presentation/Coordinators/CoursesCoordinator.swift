//
//  File.swift
//  
//
//  Created by Mazen Amr on 21/07/2026.
//

import Foundation
import SwiftUI
import Common

public final class CoursesCoordinator: ObservableObject, Coordinator {
    public let id = UUID()
    public var childCoordinators: [any Coordinator] = []
    
    @Published public var path = NavigationPath()
    
    public init() {}
    
    public func push(_ route: CoursesRoute) {
        path.append(route)
    }
}
