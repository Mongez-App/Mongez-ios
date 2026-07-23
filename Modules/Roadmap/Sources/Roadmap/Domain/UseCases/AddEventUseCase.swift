//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 22/07/2026.
//

import Foundation

public protocol AddEventUseCaseProtocol {
    func execute(courseId: String) async throws
}

public class AddEventUseCase : AddEventUseCaseProtocol {
    private let roadmapRepository: RoadmapRepositoryProtocol
    
    public init(roadmapRepository: RoadmapRepositoryProtocol) {
        self.roadmapRepository = roadmapRepository
    }
    
    public func execute(courseId: String) async throws {
        
    }
}
