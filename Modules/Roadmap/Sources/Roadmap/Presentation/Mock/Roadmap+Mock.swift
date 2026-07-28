//
//  Roadmap+Mock.swift
//
//
//  Created by Claude on 23/07/2026.
//

import Foundation

// Mock for previews/UI until GetRoadmapUseCase is wired up by the Data/Domain layers.
extension Roadmap {
    static let mock = Roadmap(
        roadmapStartDate: "2026-05-06",
        weeks: [
            Week(
                weekNumber: 1,
                startDate: "May 6",
                endDate: "May 12",
                studyBlocks: [
                    StudyBlock(
                        blockId: "block_algorithms_w1",
                        courseId: "course_algorithms",
                        courseName: "Algorithms",
                        tasks: [
                            RoadmapTask(topic: "Finish Graph Assignment", durationMinutes: 90, taskDate: "May 7 - 11:59 PM"),
                            RoadmapTask(topic: "Review DFS/BFS", durationMinutes: 45, taskDate: "May 6 - 8:00 PM")
                        ],
                        isCompleted: true,
                        events: [
                            Event(title: "Algorithms Exam", eventType: "Exam", eventDate: "May 8 - 3:00 PM")
                        ]
                    )
                ]
            ),
            Week(
                weekNumber: 2,
                startDate: "May 13",
                endDate: "May 19",
                studyBlocks: [
                    StudyBlock(
                        blockId: "block_database_w2",
                        courseId: "course_database",
                        courseName: "Database Systems",
                        tasks: [
                            RoadmapTask(topic: "Normalize Schema Exercise", durationMinutes: 60, taskDate: "May 14 - 6:00 PM")
                        ],
                        isCompleted: true,
                        events: []
                    ),
                    StudyBlock(
                        blockId: "block_networks_w2",
                        courseId: "course_networks",
                        courseName: "Networks",
                        tasks: [
                            RoadmapTask(topic: "Read TCP/IP Chapter", durationMinutes: 50, taskDate: "May 17 - 7:00 PM")
                        ],
                        isCompleted: false,
                        events: []
                    )
                ]
            ),
            Week(
                weekNumber: 3,
                startDate: "May 20",
                endDate: "May 26",
                studyBlocks: [
                    StudyBlock(
                        blockId: "block_os_w3",
                        courseId: "course_os",
                        courseName: "Operating Systems",
                        tasks: [
                            RoadmapTask(topic: "Scheduling Algorithms Lab", durationMinutes: 75, taskDate: "May 21 - 5:00 PM")
                        ],
                        isCompleted: false,
                        events: [
                            Event(title: "OS Quiz", eventType: "Quiz", eventDate: "May 25 - 1:00 PM")
                        ]
                    ),
                    StudyBlock(
                        blockId: "block_networks_w3",
                        courseId: "course_networks",
                        courseName: "Networks",
                        tasks: [],
                        isCompleted: false,
                        events: []
                    )
                ]
            ),
            Week(
                weekNumber: 4,
                startDate: "May 20",
                endDate: "May 26",
                studyBlocks: [
                    StudyBlock(
                        blockId: "block_database_w4",
                        courseId: "course_database",
                        courseName: "Database Systems",
                        tasks: [],
                        isCompleted: false,
                        events: []
                    ),
                    StudyBlock(
                        blockId: "block_algorithms_w4",
                        courseId: "course_algorithms",
                        courseName: "Algorithms",
                        tasks: [],
                        isCompleted: false,
                        events: []
                    )
                ]
            )
        ]
    )
}
