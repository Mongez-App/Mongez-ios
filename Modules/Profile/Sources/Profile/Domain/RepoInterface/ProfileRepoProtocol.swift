//
//  File.swift
//  
//
//  Created by Shady Eldakrory on 21/07/2026.
//

import Foundation
protocol ProfileRepositoryProtocol {
    func fetchProfile() async throws -> UserProfile
}
