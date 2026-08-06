//
//  File.swift
//  
//
//  Created by Mazen Amr on 06/08/2026.
//

import Foundation

public struct InitUploadRequestDTO: Codable {
    public let file_name: String
    public let content_type: String
    public let file_size_bytes: Int
    public let page_count: Int
    public let device_file_uri: String
    
    public init(file_name: String, content_type: String, file_size_bytes: Int, page_count: Int, device_file_uri: String) {
        self.file_name = file_name
        self.content_type = content_type
        self.file_size_bytes = file_size_bytes
        self.page_count = page_count
        self.device_file_uri = device_file_uri
    }
}
