//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 23/07/2026.
//

import Foundation

public class RoadmapRepository : RoadmapRepositoryProtocol {
    private let remoteDataSource: RoadmapRemoteDataSourceProtocol
    
    public init(remoteDataSource: RoadmapRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    public func getRoadmap(date: String) async throws -> Roadmap {
        let roadmapDTO = try await remoteDataSource.getRoadmap(date: date)
        
        let roadmap = RoadmapDTO.mapToEntity(roadmapDTO)
        
        return roadmap
    }
    
    public func getCourses() async throws -> [Course] {
        let courseDTOs = try await remoteDataSource.getCourses()
        
        let courses = courseDTOs.map { CourseDTO.mapToEntity(dto: $0) }
        
        return courses
    }
    
    public func addEvent(courseId: String, event: Event) async throws -> String {
        let eventResponse = try await remoteDataSource.addEvent(courseId: courseId, event: event)
        
        let message = eventResponse.message
        
        return message
    }
    
    
}
