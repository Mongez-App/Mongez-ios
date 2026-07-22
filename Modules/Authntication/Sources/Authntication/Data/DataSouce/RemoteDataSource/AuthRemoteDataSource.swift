//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//
import Foundation
import Common
public protocol AuthRemoteDataSourceProtocol {
    func handshake(idToken : String, isGuest : Bool) async throws -> AuthResponseDTO
}
 
public class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    public init() {}
 
    public func handshake(idToken : String , isGuest : Bool) async throws -> AuthResponseDTO {
        try await NetworkManger.shared.request(endpoint: AuthEndpoint.handshake(idToken: idToken, isGuest: isGuest), responseType: AuthResponseDTO.self)
    }
}
 
