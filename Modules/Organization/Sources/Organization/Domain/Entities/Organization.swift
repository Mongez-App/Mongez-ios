//
//  Organization.swift
//  
//
//  Created by Mongez on 01/08/2026.
//

import Foundation

/// A team/organization the student is a member of (approved).
public struct Team: Identifiable, Equatable {
    public let id: String
    public var name: String
    public var type: String
    public var memberCount: Int
    public var completionPercentage: Double
    public var eventText: String
    public var logoColorHex: String
    public var inviteCode: String?

    public init(
        id: String = UUID().uuidString,
        name: String,
        type: String = "Academic Organization",
        memberCount: Int = 0,
        completionPercentage: Double = 0,
        eventText: String = "",
        logoColorHex: String = "#4F46E5",
        inviteCode: String? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.memberCount = memberCount
        self.completionPercentage = completionPercentage
        self.eventText = eventText
        self.logoColorHex = logoColorHex
        self.inviteCode = inviteCode
    }
}

/// A pending join request (pending invite) waiting for team approval.
public struct PendingRequest: Identifiable, Equatable {
    public let id: String
    public var teamName: String
    public var organizationName: String
    public var appliedDateText: String
    public var status: String

    public init(
        id: String = UUID().uuidString,
        teamName: String,
        organizationName: String = "",
        appliedDateText: String,
        status: String = "Pending"
    ) {
        self.id = id
        self.teamName = teamName
        self.organizationName = organizationName
        self.appliedDateText = appliedDateText
        self.status = status
    }
}

/// A course assigned within a team.
public struct TeamCourse: Identifiable, Equatable {
    public let id: String
    public var name: String
    public var courseCode: String
    public var completionPercentage: Double
    public var dateText: String

    public init(
        id: String = UUID().uuidString,
        name: String,
        courseCode: String = "",
        completionPercentage: Double = 0,
        dateText: String = ""
    ) {
        self.id = id
        self.name = name
        self.courseCode = courseCode
        self.completionPercentage = completionPercentage
        self.dateText = dateText
    }
}

/// An event belonging to a team (upcoming or past).
public struct TeamEvent: Identifiable, Equatable {
    public let id: String
    public var title: String
    public var teamName: String
    public var dateText: String
    public var eventType: String

    public init(
        id: String = UUID().uuidString,
        title: String,
        teamName: String = "",
        dateText: String = "",
        eventType: String = "upcoming"
    ) {
        self.id = id
        self.title = title
        self.teamName = teamName
        self.dateText = dateText
        self.eventType = eventType
    }
}

/// Task progress summary for a team.
public struct TaskProgress: Identifiable, Equatable {
    public let id: String
    public var teamName: String
    public var completedTasks: Int
    public var totalTasks: Int

    public init(
        id: String = UUID().uuidString,
        teamName: String,
        completedTasks: Int = 0,
        totalTasks: Int = 0
    ) {
        self.id = id
        self.teamName = teamName
        self.completedTasks = completedTasks
        self.totalTasks = totalTasks
    }
}

/// Team-centric dashboard payload: approved teams, upcoming events,
/// task progress and pending invites.
public struct OrganizationScreen: Equatable {
    public var approvedTeams: [Team]
    public var upcomingEvents: [TeamEvent]
    public var taskProgress: [TaskProgress]
    public var pendingInvites: [PendingRequest]

    public init(
        approvedTeams: [Team] = [],
        upcomingEvents: [TeamEvent] = [],
        taskProgress: [TaskProgress] = [],
        pendingInvites: [PendingRequest] = []
    ) {
        self.approvedTeams = approvedTeams
        self.upcomingEvents = upcomingEvents
        self.taskProgress = taskProgress
        self.pendingInvites = pendingInvites
    }
}

// Mock for previews & tests
extension Team {
    static func getMockTeams() -> [Team] {
        [
            Team(
                name: "Mobile Native",
                memberCount: 128,
                completionPercentage: 75,
                eventText: "2 Quizzes this week",
                logoColorHex: "#3F51B5"
            ),
            Team(
                name: "Data Science Club",
                memberCount: 96,
                completionPercentage: 40,
                eventText: "1 Assignment due",
                logoColorHex: "#009688"
            ),
            Team(
                name: "UX Research Group",
                memberCount: 62,
                completionPercentage: 90,
                eventText: "No events this week",
                logoColorHex: "#E91E63"
            )
        ]
    }
}

extension PendingRequest {
    static func getMockPendingRequests() -> [PendingRequest] {
        [
            PendingRequest(
                teamName: "Beta AI Builders",
                organizationName: "AI Innovation Center",
                appliedDateText: "Applied May 25"
            ),
            PendingRequest(
                teamName: "Algorithms Lab & Study",
                organizationName: "Computer Science Dept",
                appliedDateText: "Applied May 20"
            )
        ]
    }
}

extension TeamCourse {
    static func getMockCourses(teamId: String) -> [TeamCourse] {
        [
            TeamCourse(id: "\(teamId)_c1", name: "Operating Systems", courseCode: "CS301", completionPercentage: 75),
            TeamCourse(id: "\(teamId)_c2", name: "Data Structures", courseCode: "CS201", completionPercentage: 40),
            TeamCourse(id: "\(teamId)_c3", name: "Algorithms", courseCode: "CS202", completionPercentage: 90)
        ]
    }
}

extension TaskProgress {
    static func getMockTaskProgress() -> [TaskProgress] {
        [
            TaskProgress(teamName: "Mobile Native", completedTasks: 9, totalTasks: 12),
            TaskProgress(teamName: "Data Science Club", completedTasks: 5, totalTasks: 10)
        ]
    }
}

extension TeamEvent {
    static func getMockEvents(teamId: String) -> (upcoming: [TeamEvent], past: [TeamEvent]) {
        (
            upcoming: [
                TeamEvent(id: "\(teamId)_e1", title: "Quiz 1", dateText: "In 3 days", eventType: "upcoming"),
                TeamEvent(id: "\(teamId)_e2", title: "Midterm", dateText: "In 1 week", eventType: "upcoming")
            ],
            past: [
                TeamEvent(id: "\(teamId)_e3", title: "Quiz 0", dateText: "2 weeks ago", eventType: "past")
            ]
        )
    }
}
