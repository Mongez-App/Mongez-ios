//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 22/07/2026.
//

import Foundation

public struct Roadmap {
    let roadmapStartDate: String
    let weeks: [Week]
}


public struct Week {
    let weekNumber: Int
    let startDate: String
    let endDate: String
    let studyBlocks: [StudyBlock]
}

public struct StudyBlock {
    let blockId: String
    let courseId: String
    let courseName: String
    let tasks: [Task]
    let isCompleted: Bool
    let events: [Event]
}

public struct Task {
    let topic: String
    let durationMinutes: Int
    let taskDate: String
}

public struct Event {
    let title: String
    let eventType: String
    let eventDate: String
}

