import Foundation
import Common

enum CoursesEndPoint: EndPoint {
    case listCourses
    case createCourse(body: Data)
    case getCourse(id: String)
    case updateCourse(id: String, body: Data)
    case deleteCourse(id: String)
    case addMaterialMetadata(courseId: String, body: Data)
    case uploadMaterialFile(uploadId: String, body: Data, boundary: String)
    case addCourseFromURL(body: Data)

    var baseURL: String {
        return "https://api-gateway-production-3fd0.up.railway.app/api/v1/"
    }

    var path: String {
        switch self {
        case .listCourses:
            return "courses"
        case .createCourse:
            return "courses"
        case .getCourse(let id):
            return "courses/\(id)"
        case .updateCourse(let id, _):
            return "courses/\(id)"
        case .deleteCourse(let id):
            return "courses/\(id)"
        case .addMaterialMetadata(let courseId, _):
            return "courses/\(courseId)/materials"
        case .uploadMaterialFile(let uploadId, _, _):
            return "upload/\(uploadId)"
        case .addCourseFromURL:
            return "courses/url"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listCourses, .getCourse:
            return .get
        case .createCourse, .addMaterialMetadata, .uploadMaterialFile, .addCourseFromURL:
            return .post
        case .updateCourse:
            return .patch
        case .deleteCourse:
            return .delete
        }
    }

    var headers: [String: String]? {
        var headers: [String: String] = [:]

        if let token = UserDefaults.standard.string(forKey: "main_token") {
            headers["Authorization"] = "Bearer \(token)"
        }

        if let userId = UserDefaults.standard.string(forKey: "current_user_id") {
            headers["x-user-id"] = userId
            headers["X-User-Id"] = userId
        }

        switch self {
        case .uploadMaterialFile(_, _, let boundary):
            headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        default:
            headers["Content-Type"] = "application/json"
        }

        return headers
    }

    var body: Data? {
        switch self {
        case .createCourse(let body), .updateCourse(_, let body),
             .addMaterialMetadata(_, let body), .addCourseFromURL(let body),
             .uploadMaterialFile(_, let body, _):
            return body
        default:
            return nil
        }
    }
}

