//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import Common

public protocol CourseDetailsRepository {
    func getMaterials(courseId: String) async throws -> [CourseMaterial]
    func getTasks(courseId: String) async throws -> [CourseTask]
    
    func uploadMaterial(
        courseId: String,
        fileData: Data,
        fileName: String,
        dailyStudyMinutes: Int?,
        preferredDays: String?  
    ) async throws -> CourseMaterial
    func updateCourse(courseId: String, name: String?, imageUrl: String?, isHidden: Bool?) async throws -> Course
    func deleteCourse(courseId: String) async throws
    func deleteMaterial(courseId: String, materialId: String) async throws
}
