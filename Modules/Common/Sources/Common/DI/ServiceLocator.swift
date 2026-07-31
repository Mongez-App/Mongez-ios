//
//  File.swift
//  
//
//  Created by Mazen Amr on 24/07/2026.
//

import Foundation

public class ServiceLocator {
    public static func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return DIContainer.shared.resolve(serviceType)
    }
    
    public static func resolve<Service, Arg1, Arg2>(
        _ serviceType: Service.Type,
        arguments arg1: Arg1,
        _ arg2: Arg2
    ) -> Service? {
        return DIContainer.shared.resolve(serviceType, arguments: arg1, arg2)
    }
}
