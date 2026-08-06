//
//  RoadmapFilterState.swift
//
//

import Foundation

enum RoadmapFilterEventType: String, CaseIterable, Identifiable, Hashable {
    case study = "Study"
    case assignment = "Assignment"
    case quiz = "Quiz"
    case exam = "Exam"
    case reminder = "Reminder"

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .study: return "book.closed.fill"
        case .assignment: return "list.clipboard.fill"
        case .quiz: return "questionmark.circle"
        case .exam: return "graduationcap.fill"
        case .reminder: return "alarm"
        }
    }

    /// Matches against an `Event.eventType` string coming from the API (case-insensitive).
    func matches(_ eventType: String) -> Bool {
        eventType.caseInsensitiveCompare(rawValue) == .orderedSame
    }
}

/// Filtering is entirely local — the roadmap endpoint only accepts a single `start_date`,
/// so the date range, course and event type filters below are all applied client-side
/// against the already-fetched `Roadmap`.
struct RoadmapFilterState: Equatable {
    var dateRange: ClosedRange<Date>?
    var courseIds: Set<String> = []
    var eventTypes: Set<RoadmapFilterEventType> = []

    var isActive: Bool {
        dateRange != nil || !courseIds.isEmpty || !eventTypes.isEmpty
    }

    var activeCount: Int {
        (dateRange != nil ? 1 : 0) + courseIds.count + eventTypes.count
    }
}
