//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//
import Foundation
import Common
public protocol AuthRemoteDataSourceProtocol {
    func handshake(idToken: String, name: String, appearance: String, language: String) async throws -> (dto: AuthResponseDTO, statusCode: Int)
    func getMe(idToken: String) async throws -> AuthResponseDTO
}
 
public class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    public init() {}
 
    public func handshake(idToken: String, name: String, appearance: String, language: String) async throws -> (dto: AuthResponseDTO, statusCode: Int) {
        let result = try await NetworkManger.shared.requestWithStatus(
            endpoint: AuthEndpoint.handshake(idToken: idToken, name: name, appearance: appearance, language: language),
            responseType: AuthResponseDTO.self
        )
        return (dto: result.decoded, statusCode: result.statusCode)
    }
    
    public func getMe(idToken: String) async throws -> AuthResponseDTO {
        try await NetworkManger.shared.request(
            endpoint: AuthEndpoint.me(idToken: idToken),
            responseType: AuthResponseDTO.self
        )
    }
}
 
