import Foundation
import Common

enum CoursesEndPoint: EndPoint {
    case listCourses
    case createCourse(body: Data)
    case getCourse(id: String)
    case updateCourse(id: String, body: Data)
    case deleteCourse(id: String)
    case uploadMaterialFile(courseId: String, body: Data, boundary: String)
    case listMaterials(courseId: String)
    case createTasks(courseId: String, body: Data)
    case listTasks(courseId: String)
    case createEvent(courseId: String, body: Data)
    case listEvents(courseId: String)
    case addCourseFromURL(body: Data)

    var baseURL: String {
        return "https://course-import-service.vercel.app/api/v1/"
    }

    var path: String {
        switch self {
        case .listCourses:
            return "rag/courses"
        case .createCourse:
            return "rag/courses"
        case .getCourse(let id):
            return "rag/courses/\(id)"
        case .updateCourse(let id, _):
            return "rag/courses/\(id)"
        case .deleteCourse(let id):
            return "rag/courses/\(id)"
        case .uploadMaterialFile(let courseId, _, _):
            return "rag/courses/\(courseId)/upload"
        case .listMaterials(let courseId):
            return "rag/courses/\(courseId)/documents"
        case .createTasks(let courseId, _):
            return "rag/courses/\(courseId)/tasks"
        case .listTasks(let courseId):
            return "rag/courses/\(courseId)/tasks"
        case .createEvent(let courseId, _):
            return "rag/courses/\(courseId)/events"
        case .listEvents(let courseId):
            return "rag/courses/\(courseId)/events"
        case .addCourseFromURL:
            return "rag/courses/url"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listCourses, .getCourse, .listMaterials, .listTasks, .listEvents:
            return .get
        case .createCourse, .uploadMaterialFile, .addCourseFromURL, .createTasks, .createEvent:
            return .post
        case .updateCourse:
            return .patch
        case .deleteCourse:
            return .delete
        }
    }

    var headers: [String: String]? {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"

        if let userId = UserDefaults.standard.string(forKey: "current_user_id") {
            headers["x-user-id"] = userId
        }

        switch self {
        case .uploadMaterialFile(_, _, let boundary):
            headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        default:
            break
        }

        return headers
    }

    var body: Data? {
        switch self {
        case .createCourse(let body), .updateCourse(_, let body),
             .addCourseFromURL(let body),
             .uploadMaterialFile(_, let body, _), .createTasks(_, let body), .createEvent(_, let body):
            return body
        default:
            return nil
        }
    }
}
