//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 22/07/2026.
//

import Foundation

struct Roadmap {
    let roadmapStartDate: String
    let weeks: [Week]
}


struct Week {
    let weekNumber: Int
    let startDate: String
    let endDate: String
    let studyBlocks: [StudyBlock]
}

struct StudyBlock {
    let blockId: String
    let courseId: String
    let courseName: String
    let tasks: [Task]
    let isCompleted: Bool
    let events: [Event]
}

struct Task {
    let topic: String
    let durationMinutes: Int
    let taskDate: String
}

struct Event {
    let title: String
    let eventType: String
    let eventDate: String
}

