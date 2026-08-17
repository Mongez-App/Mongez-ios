//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation

public struct TeamCourseMaterialsResponseDTO: Codable {
    public let courseId: String?
    public let materials: [TeamCourseMaterialDTO]?
    public let total: Int?
}

public struct TeamCourseMaterialDTO: Codable {
    public let id: String
    public let fileName: String
    public let pageCount: Int?
    public let fileSizeMb: Double?
    public let fileUrl: String?
}

public extension TeamCourseMaterialDTO {
    func toDomain() -> TeamCourseMaterial {
        let actualName: String = fileName
        let cloudinaryUrl: String? = fileUrl
        
        return TeamCourseMaterial(
            id: id,
            name: actualName,
            pageCount: pageCount ?? 0,
            fileSizeMB: fileSizeMb ?? 0.0,
            status: "COMPLETED", // Assuming completed since they are fetched from org
            uploadedAt: "",
            materialPath: cloudinaryUrl
        )
    }
}
