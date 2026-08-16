//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 15/08/2026.
//

import Foundation
import Common

public protocol OrganizationRemoteDataSourceProtocol {
    func fetchUserTeams() async throws -> [TeamDTO]
}


public class OrganizationRemoteDataSource : OrganizationRemoteDataSourceProtocol {
    public init() {}
    
    public func fetchUserTeams() async throws -> [TeamDTO] {
        try await NetworkManger.shared.request(endpoint: OrganizationEndpoints.userTeams(method: .get, path: "/teams"), responseType: [TeamDTO].self)
    }
}
