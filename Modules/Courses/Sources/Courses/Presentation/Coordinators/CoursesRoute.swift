import Foundation
public enum CoursesRoute: Hashable {
    case details(courseId: String, courseName: String, courseType: String)
    case teamDetails(courseId: String, organizationId: String, courseName: String, courseType: String)
}

