//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 22/07/2026.
//

import Foundation

public protocol RoadmapRepositoryProtocol {
    func getRoadmap(date: String) async throws -> Roadmap
    func getCourses() async throws -> [Course]
    func addEvent(courseId: String, event: Event) async throws -> String
}
