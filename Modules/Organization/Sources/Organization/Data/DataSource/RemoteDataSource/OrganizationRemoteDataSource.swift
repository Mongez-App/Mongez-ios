//
//  OrganizationRemoteDataSource.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation
import Common

public protocol OrganizationRemoteDataSourceProtocol {
    func fetchMyTeams() async throws -> [TeamDTO]
    func fetchMyCourses() async throws -> [TeamCourseDTO]
    func joinTeam(inviteCode: String) async throws
    func searchTeams(query: String) async throws -> [TeamDTO]
    func fetchOrganizationScreen() async throws -> OrganizationScreenDTO
    func fetchTeamCourses(teamId: String) async throws -> [TeamCourseDTO]
    func fetchTeamEvents(teamId: String) async throws -> TeamEventsDTO
}

public class OrganizationRemoteDataSource: OrganizationRemoteDataSourceProtocol {
    public init() {}

    public func fetchMyTeams() async throws -> [TeamDTO] {
        let response: APIEnvelope<TeamListWrapperDTO> = try await NetworkManger.shared.request(
            endpoint: OrganizationEndpoints.myTeams,
            responseType: APIEnvelope<TeamListWrapperDTO>.self
        )
        return response.data?.teams ?? []
    }

    public func fetchMyCourses() async throws -> [TeamCourseDTO] {
        let response: APIEnvelope<TeamCoursesWrapperDTO> = try await NetworkManger.shared.request(
            endpoint: OrganizationEndpoints.myCourses,
            responseType: APIEnvelope<TeamCoursesWrapperDTO>.self
        )
        return response.data?.courses ?? []
    }

    public func joinTeam(inviteCode: String) async throws {
        let (data, statusCode) = try await NetworkManger.shared.requestRaw(
            endpoint: OrganizationEndpoints.joinTeam(inviteCode: inviteCode)
        )

        if let envelope = try? JSONDecoder().decode(APIEnvelope<EmptyData>.self, from: data) {
            if envelope.success == false, let error = envelope.error {
                throw OrganizationError.server(message: error.resolved)
            }
            if (200...299).contains(statusCode) {
                return
            }
        }

        if !(200...299).contains(statusCode) {
            throw OrganizationError.invalidResponse
        }
    }

    public func searchTeams(query: String) async throws -> [TeamDTO] {
        let response: APIEnvelope<TeamSearchResultsDTO> = try await NetworkManger.shared.request(
            endpoint: OrganizationEndpoints.searchTeams(query: query),
            responseType: APIEnvelope<TeamSearchResultsDTO>.self
        )
        return response.data?.results ?? []
    }

    public func fetchOrganizationScreen() async throws -> OrganizationScreenDTO {
        let response: APIEnvelope<OrganizationScreenDTO> = try await NetworkManger.shared.request(
            endpoint: OrganizationEndpoints.teamScreen,
            responseType: APIEnvelope<OrganizationScreenDTO>.self
        )
        guard let screen = response.data else {
            if let error = response.error {
                throw OrganizationError.server(message: error.resolved)
            }
            throw OrganizationError.invalidResponse
        }
        return screen
    }

    public func fetchTeamCourses(teamId: String) async throws -> [TeamCourseDTO] {
        let response: APIEnvelope<TeamCoursesWrapperDTO> = try await NetworkManger.shared.request(
            endpoint: OrganizationEndpoints.teamCourses(teamId: teamId),
            responseType: APIEnvelope<TeamCoursesWrapperDTO>.self
        )
        return response.data?.courses ?? []
    }

    public func fetchTeamEvents(teamId: String) async throws -> TeamEventsDTO {
        let response: APIEnvelope<TeamEventsDTO> = try await NetworkManger.shared.request(
            endpoint: OrganizationEndpoints.teamEvents(teamId: teamId),
            responseType: APIEnvelope<TeamEventsDTO>.self
        )
        guard let events = response.data else {
            if let error = response.error {
                throw OrganizationError.server(message: error.resolved)
            }
            throw OrganizationError.invalidResponse
        }
        return events
    }
}

public enum OrganizationError: Error, LocalizedError {
    case invalidResponse
    case server(message: String)

    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .server(let message):
            return message
        }
    }
}

/// Used to decode the `{ success, data, error }` envelope for responses with no body.
public struct EmptyData: Decodable {}
