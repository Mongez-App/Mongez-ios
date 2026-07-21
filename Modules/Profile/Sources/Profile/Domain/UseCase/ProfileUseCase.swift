//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation
protocol GetProfileUseCaseProtocol {
    func execute() async throws -> UserProfile
}

class GetProfileUseCase: GetProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> UserProfile {
        return try await repository.fetchProfile()
    }
}
