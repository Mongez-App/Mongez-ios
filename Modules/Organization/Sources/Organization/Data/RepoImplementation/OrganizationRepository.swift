//
//  OrganizationRepository.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation

public class OrganizationRepository: OrganizationRepositoryProtocol {
    var remoteDataSource: OrganizationRemoteDataSourceProtocol
    var localDataSource: OrganizationLocalDataSourceProtocol

    public init(
        remoteDataSource: OrganizationRemoteDataSourceProtocol,
        localDataSource: OrganizationLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    public func getMyTeams() async throws -> [Team] {
        do {
            let teamDTOs = try await remoteDataSource.fetchMyTeams()
            return teamDTOs.map { TeamDTO.mapToEntity(team: $0) }
        } catch {
            print("Remote fetch of my teams failed (\(error)). Falling back to local data.")
            let teamDTOs = try await localDataSource.fetchMyTeams()
            return teamDTOs.map { TeamDTO.mapToEntity(team: $0) }
        }
    }

    public func getOrganizationScreen() async throws -> OrganizationScreen {
        do {
            let screenDTO = try await remoteDataSource.fetchOrganizationScreen()
            return OrganizationScreenDTO.mapToEntity(screen: screenDTO)
        } catch {
            print("Remote fetch of organization screen failed (\(error)). Falling back to local data.")
            let screenDTO = try await localDataSource.fetchOrganizationScreen()
            return OrganizationScreenDTO.mapToEntity(screen: screenDTO)
        }
    }

    public func searchTeams(query: String) async throws -> [Team] {
        let teamDTOs = try await remoteDataSource.searchTeams(query: query)
        return teamDTOs.map { TeamDTO.mapToEntity(team: $0) }
    }

    public func joinTeam(code: String) async throws {
        try await remoteDataSource.joinTeam(inviteCode: code)
    }

    public func getMyCourses() async throws -> [TeamCourse] {
        let courseDTOs = try await remoteDataSource.fetchMyCourses()
        return courseDTOs.map { TeamCourseDTO.mapToEntity(course: $0) }
    }

    public func getTeamCourses(teamId: String) async throws -> [TeamCourse] {
        let courseDTOs = try await remoteDataSource.fetchTeamCourses(teamId: teamId)
        return courseDTOs.map { TeamCourseDTO.mapToEntity(course: $0) }
    }

    public func getTeamEvents(teamId: String) async throws -> (upcoming: [TeamEvent], past: [TeamEvent]) {
        let eventsDTO = try await remoteDataSource.fetchTeamEvents(teamId: teamId)
        let upcoming = eventsDTO.upcoming.map { TeamEventDTO.mapToEntity(event: $0) }
        let past = eventsDTO.past.map { TeamEventDTO.mapToEntity(event: $0) }
        return (upcoming: upcoming, past: past)
    }
}
