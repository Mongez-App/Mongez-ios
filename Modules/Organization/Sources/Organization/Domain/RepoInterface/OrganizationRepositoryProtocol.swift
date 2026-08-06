//
//  OrganizationRepositoryProtocol.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation

public protocol OrganizationRepositoryProtocol {
    func getMyTeams() async throws -> [Team]
    func getMyCourses() async throws -> [TeamCourse]
    func getOrganizationScreen() async throws -> OrganizationScreen
    func searchTeams(query: String) async throws -> [Team]
    func joinTeam(code: String) async throws
    func getTeamCourses(teamId: String) async throws -> [TeamCourse]
    func getTeamEvents(teamId: String) async throws -> (upcoming: [TeamEvent], past: [TeamEvent])
}
