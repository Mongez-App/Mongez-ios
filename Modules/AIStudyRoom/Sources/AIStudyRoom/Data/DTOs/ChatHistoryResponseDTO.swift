//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation

struct ChatHistoryResponseDTO: Decodable {
    let course_id: String
    let messages: [ChatMessageDTO]
    let has_more: Bool
}
