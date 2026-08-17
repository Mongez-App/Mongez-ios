import Foundation

public protocol TeamCoursesRepositoryProtocol {
    func fetchTeamCourses(teamId: String, organizationId: String) async throws -> [TeamCourse]
    func fetchTeamEvents(teamId: String, organizationId: String) async throws -> [TeamEvent]
}
