import Foundation
import Common

enum CoursesEndPoint: EndPoint {
    case listCourses
    case createCourse(body: Data)
    case getCourse(id: String)
    case updateCourse(id: String, body: Data)
    case deleteCourse(id: String)
    case createMaterial(courseId: String, body: Data)
    case uploadMaterialPDF(materialId: String, body: Data, boundary: String)
    case listMaterials(courseId: String)
    case deleteMaterial(courseId: String, materialId: String)

    var baseURL: String {
        return "https://api-gateway-production-5110.up.railway.app/api/v1/"
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
        case .createMaterial(let courseId, _):
            return "courses/\(courseId)/materials"
        case .uploadMaterialPDF(let materialId, _, _):
            return "upload/\(materialId)"
        case .listMaterials(let courseId):
            return "courses/\(courseId)/materials"
        case .deleteMaterial(let courseId, let materialId):
            return "courses/\(courseId)/materials/\(materialId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listCourses, .getCourse, .listMaterials:
            return .get
        case .createCourse, .createMaterial, .uploadMaterialPDF:
            return .post
        case .updateCourse:
            return .patch
        case .deleteCourse, .deleteMaterial:
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
        case .uploadMaterialPDF(_, _, let boundary):
            headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        default:
            headers["Content-Type"] = "application/json"
        }

        return headers
    }

    var body: Data? {
        switch self {
        case .createCourse(let body), .updateCourse(_, let body),
             .createMaterial(_, let body), .uploadMaterialPDF(_, let body, _):
            return body
        default:
            return nil
        }
    }
}
