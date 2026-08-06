//
//  File.swift
//  
//
//  Created by Mazen Amr on 24/07/2026.
//

import Foundation
import Swinject

public class DIContainer {
    public static let shared = DIContainer()
    
    private let container: Container
    
    private init() {
        self.container = Container()
      //  registerDefaultServices()
    }

//    private func registerDefaultServices() {
//        
//    }
    
    public func register<Service>(
        _ serviceType: Service.Type,
        factory: @escaping (Resolver) -> Service
    ) {
        container.register(serviceType) { factory($0) }
    }
    
    public func register<Service, Arg1, Arg2>(
        _ serviceType: Service.Type,
        factory: @escaping (Resolver, Arg1, Arg2) -> Service
    ) {
        container.register(serviceType) { factory($0, $1, $2) }
    }
    
    public func register<Service>(
        _ serviceType: Service.Type,
        name: String?,
        factory: @escaping (Resolver) -> Service
    ) {
        container.register(serviceType, name: name) { factory($0) }
    }
    
    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return container.resolve(serviceType)
    }
    
    public func resolve<Service, Arg1, Arg2>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2
    ) -> Service? {
        return container.resolve(serviceType, arguments: arg1, arg2)
    }
    
    public func resolve<Service>(_ serviceType: Service.Type, name: String?) -> Service? {
        return container.resolve(serviceType, name: name)
    }
    
    public func resolve<Service, Arg1, Arg2, Arg3>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2,
        _ arg3: Arg3
    ) -> Service? {
        return container.resolve(serviceType, arguments: arg1, arg2, arg3)
    }
    
    public func register<Service, Arg1, Arg2, Arg3>(
        _ serviceType: Service.Type,
        factory: @escaping (Resolver, Arg1, Arg2, Arg3) -> Service
    ) {
        container.register(serviceType) { factory($0, $1, $2, $3) }
    }
    
    public func getContainer() -> Container {
        return container
    }
}
