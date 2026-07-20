//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation

public protocol Coordinator: AnyObject {
    var id: UUID { get }
    var childCoordinators: [any Coordinator] { get set }
}

public extension Coordinator {
    func addChild(_ coordinator: any Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: any Coordinator) {
        childCoordinators.removeAll { $0.id == coordinator.id }
    }
}
