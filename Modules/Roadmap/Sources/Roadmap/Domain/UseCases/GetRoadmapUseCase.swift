//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 22/07/2026.
//

import Foundation

public protocol GetRoadmapUseCaseProtocol {
    func execute() async throws -> Roadmap
}

public class GetRoadmapUseCase : GetRoadmapUseCaseProtocol {
    private let roadmapRepository: RoadmapRepositoryProtocol
    
    public init(roadmapRepository: RoadmapRepositoryProtocol) {
        self.roadmapRepository = roadmapRepository
    }
    
    public func execute() async throws -> Roadmap {
        try await roadmapRepository.getRoadmap()
    }
}
