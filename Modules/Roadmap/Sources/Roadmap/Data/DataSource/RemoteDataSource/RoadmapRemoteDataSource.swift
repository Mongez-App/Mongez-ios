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
    func getCourses() async throws -> CourseResponse
    func addEvent(courseId: String, event: Event) async throws -> EventResponse
}

public class RoadmapRemoteDataSource :  RoadmapRemoteDataSourceProtocol {
    
    public func getRoadmap(date: String) async throws -> RoadmapDTO {
        let path = "/roadmap/weekly?start_date=\(date)"
        
        return try await NetworkManger.shared.request(endpoint: RoadmapEndpoints.roadmap(method: .get, path: path), responseType: RoadmapDTO.self)
    }
    
    public func getCourses() async throws -> CourseResponse{
        try await NetworkManger.shared.request(endpoint: RoadmapEndpoints.courses(method: .get, path: "/courses"), responseType: CourseResponse.self)
    }
    
    public func addEvent(courseId: String, event: Event) async throws -> EventResponse {
        let path = "/courses/\(courseId)/events"
        
        return try await NetworkManger.shared.request(endpoint: RoadmapEndpoints.event(method: .post, path: path, event: event), responseType: EventResponse.self)
    }
    
    
}
