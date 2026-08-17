//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation

public struct TeamCourseMaterial: Identifiable {
    public let id: String
    public let name: String
    public let pageCount: Int
    public let fileSizeMB: Double
    public let status: String
    public let uploadedAt: String
    public let materialPath: String?
    
    public init(
        id: String,
        name: String,
        pageCount: Int,
        fileSizeMB: Double,
        status: String,
        uploadedAt: String,
        materialPath: String?
    ) {
        self.id = id
        self.name = name
        self.pageCount = pageCount
        self.fileSizeMB = fileSizeMB
        self.status = status
        self.uploadedAt = uploadedAt
        self.materialPath = materialPath
    }
    
    public var computedFileUrl: String {
        return "https://api-gateway-production-5110.up.railway.app/api/v1/organization/materials/\(id)/file"
    }
}
