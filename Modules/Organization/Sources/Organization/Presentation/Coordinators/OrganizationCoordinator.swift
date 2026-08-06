//
//  OrganizationCoordinator.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation
import Common
import SwiftUI

public final class OrganizationCoordinator: ObservableObject, Coordinator {
    public let id = UUID()
    public var childCoordinators: [any Coordinator] = []

    @Published public var path = NavigationPath()

    public init() {}

    public func push(_ route: OrganizationRoute) {
        path.append(route)
    }
}
