//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 18/07/2026.
//
import Foundation
import Common

public protocol AuthRemoteDataSourceProtocol {
    func studentLogin(idToken: String) async throws -> (dto: AuthStudentResponseDTO, statusCode: Int)
    func studentRegister(idToken: String) async throws -> (dto: AuthStudentResponseDTO, statusCode: Int)
    func getMe() async throws -> AuthStudentResponseDTO
    func logout() async throws
}

public class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    public init() {}

    public func studentLogin(idToken: String) async throws -> (dto: AuthStudentResponseDTO, statusCode: Int) {
        let result = try await NetworkManger.shared.requestWithStatus(
            endpoint: AuthEndpoint.studentLogin(idToken: idToken),
            responseType: AuthStudentResponseDTO.self
        )
        return (dto: result.decoded, statusCode: result.statusCode)
    }

    public func studentRegister(idToken: String) async throws -> (dto: AuthStudentResponseDTO, statusCode: Int) {
        let result = try await NetworkManger.shared.requestWithStatus(
            endpoint: AuthEndpoint.studentRegister(idToken: idToken),
            responseType: AuthStudentResponseDTO.self
        )
        return (dto: result.decoded, statusCode: result.statusCode)
    }

    public func getMe() async throws -> AuthStudentResponseDTO {
        try await NetworkManger.shared.request(
            endpoint: AuthEndpoint.studentMe,
            responseType: AuthStudentResponseDTO.self
        )
    }

    public func logout() async throws {
        _ = try await NetworkManger.shared.requestRaw(endpoint: AuthEndpoint.studentLogout)
    }
}