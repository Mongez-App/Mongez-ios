//
//  OrganizationDTO.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation

/// Standard response envelope used by course-import-service: `success`, `data`, `error`.
public struct APIEnvelope<T: Decodable>: Decodable {
    let success: Bool?
    let data: T?
    let error: APIErrorDTO?
}

/// The `error` field shape: `{ code, message }`.
public struct APIErrorDTO: Decodable {
    var code: String?
    var message: String?

    enum CodingKeys: String, CodingKey {
        case code
        case message
    }

    public var resolved: String {
        message ?? code ?? "Something went wrong, please try again."
    }
}

// MARK: - Team

public struct TeamDTO: Decodable {
    var teamId: String
    var orgId: String?
    var orgName: String?
    var teamName: String
    var description: String?
    var inviteCode: String?
    var memberCount: Int?

    enum CodingKeys: String, CodingKey {
        case teamId
        case orgId
        case orgName
        case teamName
        case description
        case inviteCode
        case memberCount
    }

    public static func mapToEntity(team: TeamDTO) -> Team {
        Team(
            id: team.teamId,
            name: team.teamName,
            type: team.orgName ?? "Academic Organization",
            memberCount: team.memberCount ?? 0,
            completionPercentage: 0,
            eventText: "",
            logoColorHex: "#4F46E5",
            inviteCode: team.inviteCode
        )
    }
}

public struct TeamListWrapperDTO: Decodable {
    let teams: [TeamDTO]
    let totalTeams: Int?
}

public struct TeamSearchResultsDTO: Decodable {
    let results: [TeamDTO]
}

// MARK: - Pending invites

public struct PendingRequestDTO: Decodable {
    var teamId: String?
    var orgName: String?
    var teamName: String
    var status: String?

    enum CodingKeys: String, CodingKey {
        case teamId
        case orgName
        case teamName
        case status
    }

    public static func mapToEntity(request: PendingRequestDTO) -> PendingRequest {
        PendingRequest(
            id: request.teamId ?? UUID().uuidString,
            teamName: request.teamName,
            organizationName: request.orgName ?? "",
            appliedDateText: "Pending approval",
            status: request.status ?? "Pending"
        )
    }
}

// MARK: - Courses

public struct TeamCourseDTO: Decodable {
    var courseId: String
    var courseName: String
    var startDate: String?
    var endDate: String?
    var studyDates: [String]?
    var documentCount: Int?
    var ownerId: String?
    var ownerType: String?
    var type: String?
    var userId: String?

    enum CodingKeys: String, CodingKey {
        case courseId
        case courseName
        case startDate
        case endDate
        case studyDates
        case documentCount
        case ownerId
        case ownerType
        case type
        case userId
    }

    public static func mapToEntity(course: TeamCourseDTO) -> TeamCourse {
        TeamCourse(
            id: course.courseId,
            name: course.courseName,
            courseCode: "",
            completionPercentage: 0,
            dateText: course.startDate ?? course.endDate ?? ""
        )
    }
}

public struct TeamCoursesWrapperDTO: Decodable {
    let courses: [TeamCourseDTO]
}

// MARK: - Events

public struct TeamEventDTO: Decodable {
    var eventId: String?
    var title: String?
    var teamName: String?
    var dateText: String?
    var eventType: String?

    enum CodingKeys: String, CodingKey {
        case eventId
        case title
        case teamName
        case dateText
        case eventType
    }

    public static func mapToEntity(event: TeamEventDTO) -> TeamEvent {
        TeamEvent(
            id: event.eventId ?? UUID().uuidString,
            title: event.title ?? "Team Event",
            teamName: event.teamName ?? "",
            dateText: event.dateText ?? "",
            eventType: event.eventType ?? "upcoming"
        )
    }
}

public struct TeamEventsDTO: Decodable {
    let upcoming: [TeamEventDTO]
    let past: [TeamEventDTO]
}

// MARK: - Team screen (dashboard)

public struct TeamScreenStatsDTO: Decodable {
    let totalTeams: Int?
    let pendingInvites: Int?
}

public struct OrganizationScreenDTO: Decodable {
    var teams: [TeamDTO]?
    var pendingInvites: [PendingRequestDTO]?
    var stats: TeamScreenStatsDTO?

    enum CodingKeys: String, CodingKey {
        case teams
        case pendingInvites
        case stats
    }

    public static func mapToEntity(screen: OrganizationScreenDTO) -> OrganizationScreen {
        OrganizationScreen(
            approvedTeams: (screen.teams ?? []).map { TeamDTO.mapToEntity(team: $0) },
            upcomingEvents: [],
            taskProgress: [],
            pendingInvites: (screen.pendingInvites ?? []).map { PendingRequestDTO.mapToEntity(request: $0) }
        )
    }
}
