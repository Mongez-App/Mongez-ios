//
//  File.swift
//  
//
//  Created by Mazen Amr on 18/07/2026.
//

import Foundation

struct ChatMessageDTO: Decodable {
    let message_id: String
    let role: String
    let content: String
    let created_at: String
}
