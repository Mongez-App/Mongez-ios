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
    
    public func getRoadmap() async throws -> Roadmap {
        let roadmapDTO = try await remoteDataSource.getRoadmap()
        
        let roadmap = RoadmapDTO.mapToEntity(roadmapDTO)
        
        return roadmap
    }
    
    public func getCourses() async throws -> Course {
        Course(courseId: "", courseName: "")
    }
    
    public func addEvent(courseId: String) async throws {
        
    }
    
    
}
