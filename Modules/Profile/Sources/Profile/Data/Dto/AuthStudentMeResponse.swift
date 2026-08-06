import Foundation

struct AuthStudentMeResponse: Decodable {
    let success: Bool?
    let data: AuthStudentMeData?
}

struct AuthStudentMeData: Decodable {
    let uid: String?
    let email: String?
    let displayName: String?
    let registeredAt: String?
}
