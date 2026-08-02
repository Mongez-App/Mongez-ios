//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 23/07/2026.
//

import Foundation
import Common

public protocol RoadmapRemoteDataSourceProtocol {
    func getRoadmap() async throws -> RoadmapDTO
    func getCourses() async throws // will add the CourseDTO when available
    func addEvent(courseId: String) async throws
}

public class RoadmapRemoteDataSource :  RoadmapRemoteDataSourceProtocol {
    
    public func getRoadmap() async throws -> RoadmapDTO {
        try await NetworkManger.shared.request(endpoint: RoadmapEndpoints.roadmap(method: .get, path: ""), responseType: RoadmapDTO.self)
    }
    
    public func getCourses() async throws {
        
    }
    
    public func addEvent(courseId: String) async throws {

    }
    
    
}
