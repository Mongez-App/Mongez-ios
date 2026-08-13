//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 22/07/2026.
//

import Foundation

public protocol GetCoursesUseCaseProtocol {
    func execute() async throws -> [Course]
}


public class GetCoursesUseCase : GetCoursesUseCaseProtocol {
    private let roadmapRepository: RoadmapRepositoryProtocol
    
    public init(roadmapRepository: RoadmapRepositoryProtocol) {
        self.roadmapRepository = roadmapRepository
    }
    
    public func execute() async throws -> [Course] {
        let courses = try await roadmapRepository.getCourses()
        
        print(courses)
        
        return courses
    }
}
