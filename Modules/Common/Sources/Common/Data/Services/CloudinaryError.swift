//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation

public enum CloudinaryError: Error, LocalizedError {
    case invalidResponse
    case materialUploadFailed
    case imageUploadFailed

    public var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid response from server"
        case .materialUploadFailed: return "Failed to upload material"
        case .imageUploadFailed: return "Failed to upload image"
        }
    }
}
