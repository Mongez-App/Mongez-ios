import Foundation
import Common

protocol TeamCoursesRemoteDataSourceProtocol {
    func fetchTeamCourses(teamId: String, organizationId: String) async throws -> [TeamCourseDTO]
    func fetchTeamEvents(teamId: String, organizationId: String) async throws -> [TeamEventDTO]
}

final class TeamCoursesRemoteDataSource: TeamCoursesRemoteDataSourceProtocol {
    func fetchTeamCourses(teamId: String, organizationId: String) async throws -> [TeamCourseDTO] {
        let endpoint = TeamCoursesEndPoint.getTeamCourses(teamId: teamId, organizationId: organizationId)
        do {
            let response = try await NetworkManger.shared.request(
                endpoint: endpoint,
                responseType: TeamCoursesResponseDTO.self
            )
            return response.courses ?? []
        } catch {
            let response = try await NetworkManger.shared.request(
                endpoint: endpoint,
                responseType: [TeamCourseDTO].self
            )
            return response
        }
    }
    
    func fetchTeamEvents(teamId: String, organizationId: String) async throws -> [TeamEventDTO] {
        let endpoint = TeamCoursesEndPoint.getTeamEvents(teamId: teamId, organizationId: organizationId)
        do {
            let response = try await NetworkManger.shared.request(
                endpoint: endpoint,
                responseType: TeamEventsResponseDTO.self
            )
            return response.events ?? []
        } catch {
            let response = try await NetworkManger.shared.request(
                endpoint: endpoint,
                responseType: [TeamEventDTO].self
            )
            return response
        }
    }
}
