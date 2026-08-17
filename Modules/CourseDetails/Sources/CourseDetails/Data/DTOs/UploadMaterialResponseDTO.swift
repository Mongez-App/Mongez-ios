//
//  File.swift
//  
//
//  Created by Mazen Amr on 21/07/2026.
//

import Foundation

public struct UploadMaterialResponseDTO: Codable {
    public let material_id: String
    public let upload_url: String
    public let status: String?
}
