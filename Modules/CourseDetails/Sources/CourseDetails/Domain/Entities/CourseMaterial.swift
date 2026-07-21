//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation

public struct CourseMaterial: Identifiable {
    public let id: String
    public let name: String
    public let pageCount: Int
    public let fileSizeMB: Double
    
    public init(id: String, name: String, pageCount: Int, fileSizeMB: Double) {
        self.id = id
        self.name = name
        self.pageCount = pageCount
        self.fileSizeMB = fileSizeMB
    }
}
