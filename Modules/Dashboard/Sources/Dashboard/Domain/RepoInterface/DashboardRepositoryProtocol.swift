//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 23/07/2026.
//

import Foundation

protocol DashboardRepositoryProtocol {
    func fetchDashboard() async throws -> Dashboard
}
