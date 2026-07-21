//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation

class ProfileRepository: ProfileRepositoryProtocol {
    private let remoteDataSource: ProfileRemoteDataSourceProtocol
    
    init(remoteDataSource: ProfileRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchProfile() async throws -> UserProfile {
        return try await remoteDataSource.getProfile()
    }
}
