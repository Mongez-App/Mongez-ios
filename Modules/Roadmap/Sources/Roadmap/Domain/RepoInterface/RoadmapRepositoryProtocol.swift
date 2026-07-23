//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 22/07/2026.
//

import Foundation

public protocol RoadmapRepositoryProtocol {
    func getRoadmap() async throws -> Roadmap
    func getCourses() async throws -> Course
    func addEvent(courseId: String) async throws
}
