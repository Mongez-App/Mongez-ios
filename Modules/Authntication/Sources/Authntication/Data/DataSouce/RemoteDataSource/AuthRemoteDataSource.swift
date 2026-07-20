//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//
import Foundation
import Common
public protocol AuthRemoteDataSourceProtocol {
    func login(email: String, password: String, idToken: String) async throws -> AuthResponseDTO
    func register(name: String, email: String, password: String, idToken: String) async throws -> AuthResponseDTO
    func loginWithGoogle(idToken: String) async throws -> AuthResponseDTO
}
 
public class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    public init() {}
 
    public func login(email: String, password: String, idToken: String) async throws -> AuthResponseDTO {
        try await NetworkManger.shared.request(endpoint: AuthEndpoint.login(email: email, password: password, idToken: idToken), responseType: AuthResponseDTO.self)
    }
 
    public func register(name: String, email: String, password: String, idToken: String) async throws -> AuthResponseDTO {
        try await NetworkManger.shared.request(endpoint: AuthEndpoint.register(name: name, email: email, password: password, idToken: idToken), responseType: AuthResponseDTO.self)
    }
 
    public func loginWithGoogle(idToken: String) async throws -> AuthResponseDTO {
        try await NetworkManger.shared.request(endpoint: AuthEndpoint.googleLogin(idToken: idToken), responseType: AuthResponseDTO.self)
    }
}
 
