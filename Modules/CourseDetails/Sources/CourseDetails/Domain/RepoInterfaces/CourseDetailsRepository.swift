//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
public protocol CourseDetailsRepository {
    func getMaterials(courseId: String) async throws -> [CourseMaterial]
    func getTasks(courseId: String) async throws -> [CourseTask]
}
