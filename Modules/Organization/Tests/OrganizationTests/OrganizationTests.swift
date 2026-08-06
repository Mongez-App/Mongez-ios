import XCTest
@testable import Organization

final class OrganizationTests: XCTestCase {
    func testMockTeamsMapToDTOs() async throws {
        let localDataSource = OrganizationLocalDataSource()
        let teamDTOs = try await localDataSource.fetchMyTeams()

        XCTAssertEqual(teamDTOs.count, 3)
        XCTAssertEqual(teamDTOs[0].teamName, "Mobile Native")
    }

    func testMockOrganizationScreenMapsToDTOs() async throws {
        let localDataSource = OrganizationLocalDataSource()
        let screen = try await localDataSource.fetchOrganizationScreen()

        XCTAssertEqual(screen.teams?.count, 3)
        XCTAssertEqual(screen.pendingInvites?.count, 2)
    }

    func testDTOsMapToDomain() {
        let teamDTO = TeamDTO(
            teamId: "team_1",
            orgName: "ITI",
            teamName: "Mobile Native",
            memberCount: 128
        )

        let team = TeamDTO.mapToEntity(team: teamDTO)

        XCTAssertEqual(team.id, "team_1")
        XCTAssertEqual(team.name, "Mobile Native")
        XCTAssertEqual(team.memberCount, 128)
        XCTAssertEqual(team.type, "ITI")
    }

    func testUseCaseFallsBackToLocalOnRemoteFailure() async throws {
        let remoteDataSource = FailingRemoteDataSource()
        let localDataSource = OrganizationLocalDataSource()
        let repository = OrganizationRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )

        let screen = try await repository.getOrganizationScreen()
        XCTAssertEqual(screen.approvedTeams.count, 3)
    }

    func testJoinTeamEndpointBody() {
        let endpoint = OrganizationEndpoints.joinTeam(inviteCode: "ABC123")
        XCTAssertEqual(endpoint.method, .post)
        XCTAssertEqual(endpoint.path, "teams/join")
        XCTAssertTrue(endpoint.baseURL.contains("course-import-service"))

        guard let body = endpoint.body,
              let json = try? JSONSerialization.jsonObject(with: body) as? [String: String] else {
            return XCTFail("join body must be valid JSON")
        }
        XCTAssertEqual(json["inviteCode"], "ABC123")
    }

    func testJoinTeamHeadersIncludeUserID() {
        let endpoint = OrganizationEndpoints.joinTeam(inviteCode: "ABC123")
        guard let headers = endpoint.headers else {
            return XCTFail("headers must not be nil")
        }
        XCTAssertNotNil(headers["x-user-id"])
    }
}

final class FailingRemoteDataSource: OrganizationRemoteDataSourceProtocol {
    func fetchMyTeams() async throws -> [TeamDTO] {
        throw URLError(.cannotConnectToHost)
    }

    func fetchMyCourses() async throws -> [TeamCourseDTO] {
        throw URLError(.cannotConnectToHost)
    }

    func joinTeam(inviteCode: String) async throws {
        throw URLError(.cannotConnectToHost)
    }

    func searchTeams(query: String) async throws -> [TeamDTO] {
        throw URLError(.cannotConnectToHost)
    }

    func fetchOrganizationScreen() async throws -> OrganizationScreenDTO {
        throw URLError(.cannotConnectToHost)
    }

    func fetchTeamCourses(teamId: String) async throws -> [TeamCourseDTO] {
        throw URLError(.cannotConnectToHost)
    }

    func fetchTeamEvents(teamId: String) async throws -> TeamEventsDTO {
        throw URLError(.cannotConnectToHost)
    }
}
