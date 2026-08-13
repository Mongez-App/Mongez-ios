//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 23/07/2026.
//

import Foundation
import Common

public protocol RoadmapRemoteDataSourceProtocol {
    func getRoadmap(date: String) async throws -> RoadmapDTO
    func getCourses() async throws -> [CourseDTO]
    func addEvent(courseId: String, event: Event) async throws -> EventResponse
}

public class RoadmapRemoteDataSource :  RoadmapRemoteDataSourceProtocol {
    
    public init () {
        
    }
    
    public func getRoadmap(date: String) async throws -> RoadmapDTO {
        let path = "/roadmap/weekly?start_date=\(date)"
        
        return try await NetworkManger.shared.request(endpoint: RoadmapEndpoints.roadmap(method: .get, path: path), responseType: RoadmapDTO.self)
    }
    
    public func getCourses() async throws -> [CourseDTO]{
        try await NetworkManger.shared.request(endpoint: RoadmapEndpoints.courses(method: .get, path: "/courses"), responseType: [CourseDTO].self)
    }
    
    public func addEvent(courseId: String, event: Event) async throws -> EventResponse {
        let path = "/courses/\(courseId)/events"
        
        return try await NetworkManger.shared.request(endpoint: RoadmapEndpoints.event(method: .post, path: path, event: event), responseType: EventResponse.self)
    }
    
    
}
