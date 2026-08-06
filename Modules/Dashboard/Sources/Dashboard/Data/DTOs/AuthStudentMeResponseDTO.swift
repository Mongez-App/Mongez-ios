import Foundation

public struct AuthStudentMeResponseDTO: Decodable {
    public let success: Bool?
    public let data: AuthStudentMeDataDTO?
}

public struct AuthStudentMeDataDTO: Decodable {
    public let uid: String?
    public let email: String?
    public let displayName: String?
    public let registeredAt: String?
}
