import Foundation
import Common

public protocol RoadmapRemoteDataSourceProtocol {
    func getRoadmap() async throws -> RoadmapDTO
    func getCourses() async throws -> [CourseInfoDTO]
    func createEvent(courseId: String, eventType: String, title: String, dueDate: String, weight: Int) async throws
}

public struct CourseInfoDTO: Decodable {
    let courseId: String?
    let courseName: String?

    enum CodingKeys: String, CodingKey {
        case courseId
        case courseName
    }

    func toDomain() -> Course {
        Course(courseId: courseId ?? "", courseName: courseName ?? "")
    }
}

private struct CreateEventRequestBody: Encodable {
    let eventType: String
    let title: String
    let dueDate: String
    let weight: Int
}

private struct CoursesListWrapper: Decodable {
    let success: Bool?
    let data: CoursesData?
    let message: String?
}

private struct CoursesData: Decodable {
    let courses: [CourseInfoDTO]?
}

private struct EventCreateResponse: Decodable {
    let success: Bool?
    let message: String?
}

public class RoadmapRemoteDataSource: RoadmapRemoteDataSourceProtocol {

    public init() {}

    public func getRoadmap() async throws -> RoadmapDTO {
        let endpoint = RoadmapEndpoints.roadmap(method: .get, path: "rag/roadmap")
        let fullURL = endpoint.baseURL + endpoint.path
        guard let url = URL(string: fullURL) else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let responseStr = String(data: data, encoding: .utf8) ?? "?"
        print("=== ROADMAP RESPONSE ===")
        print("Status: \(statusCode)")
        print("Body: \(responseStr.prefix(2000))")
        print("========================")

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "Roadmap", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error \(statusCode): \(responseStr)"])
        }

        if let wrapper = try? JSONDecoder().decode(RoadmapResponseDTO.self, from: data),
           let roadmap = wrapper.data {
            return roadmap
        }

        return try JSONDecoder().decode(RoadmapDTO.self, from: data)
    }

    public func getCourses() async throws -> [CourseInfoDTO] {
        let endpoint = RoadmapEndpoints.courses(method: .get, path: "rag/courses")
        let fullURL = endpoint.baseURL + endpoint.path
        guard let url = URL(string: fullURL) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let raw = String(data: data, encoding: .utf8) ?? "?"
        print("=== COURSES LIST ===")
        print("Status: \(statusCode)")
        print("Body: \(raw.prefix(2000))")
        print("====================")

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "Roadmap", code: statusCode, userInfo: [NSLocalizedDescriptionKey: raw])
        }

        if let wrapper = try? JSONDecoder().decode(CoursesListWrapper.self, from: data),
           let courses = wrapper.data?.courses {
            return courses
        }

        if let arr = try? JSONDecoder().decode([CourseInfoDTO].self, from: data) {
            return arr
        }

        return []
    }

    public func createEvent(courseId: String, eventType: String, title: String, dueDate: String, weight: Int) async throws {
        let body = CreateEventRequestBody(eventType: eventType, title: title, dueDate: dueDate, weight: weight)
        let bodyData = try JSONEncoder().encode(body)

        let endpoint = RoadmapEndpoints.createEvent(
            method: .post,
            path: "rag/courses/\(courseId)/events",
            body: bodyData
        )

        let fullURL = endpoint.baseURL + endpoint.path
        guard let url = URL(string: fullURL) else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body

        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        let raw = String(data: data, encoding: .utf8) ?? "?"
        print("=== CREATE EVENT ===")
        print("Status: \(statusCode)")
        print("Body: \(raw)")
        print("====================")

        guard (200...299).contains(statusCode) else {
            throw NSError(domain: "Roadmap", code: statusCode, userInfo: [NSLocalizedDescriptionKey: raw])
        }
    }
}
