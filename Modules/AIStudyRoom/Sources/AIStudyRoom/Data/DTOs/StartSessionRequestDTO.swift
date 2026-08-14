//
//  File.swift
//  
//
//  Created by Mazen Amr on 07/08/2026.
//

import Foundation

public struct StartSessionRequestDTO: Encodable {
    public let course_id: String
    public let estimated_duration_minutes: Int
    public let linked_task_id: String
}
