//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//
import Common
import Foundation
public protocol AuthRemoteDataSourceProtocol {
    func login(email: String, password: String) async throws -> AuthResponseDTO
    func register(name: String, email: String, password: String) async throws -> AuthResponseDTO
}

public class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    public init() {}
    public func login(email: String, password: String) async throws -> AuthResponseDTO {
        try await NetworkManger.shared.request(endpoint: AuthEndpoint.login(email: email, password: password), responseType: AuthResponseDTO.self)
    }
    public func register(name: String, email: String, password: String) async throws -> AuthResponseDTO {
        try await NetworkManger.shared.request(endpoint: AuthEndpoint.register(name: name, email: email, password: password), responseType: AuthResponseDTO.self)
    }
}
