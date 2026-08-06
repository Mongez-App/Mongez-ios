//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 30/07/2026.
//

import Foundation

public struct CourseResponse : Codable {
    public let courses: [CourseDTO]
    
    public static func mapToEntity(dto: CourseResponse) -> [Course] {
        let courses = dto.courses.map {CourseDTO.mapToEntity(dto: $0)}
        
        return courses
    }
}

public struct CourseDTO : Codable {
    public let id: String
    public let userId: String?
    public let name: String
    public let courseCode: String?
    public let imageUrl: String?
    public let startDate: String?
    public let examDate: String?
    public let courseType: String?
    public let completionPercentage: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case courseCode = "course_code"
        case imageUrl = "image_url"
        case startDate = "start_date"
        case examDate = "exam_date"
        case courseType = "course_type"
        case completionPercentage = "completion_percentage"
    }

    public static func mapToEntity(dto: CourseDTO) -> Course {
        let course = Course(
            courseId: dto.id,
            courseName: dto.name
        )
        
        return course
    }
}
