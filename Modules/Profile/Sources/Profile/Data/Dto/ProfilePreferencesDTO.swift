import Foundation

public struct ProfilePreferencesDTO: Decodable {
    public let studyDays: [Int]?
    public let dailyStudyHours: Float?
    
    enum CodingKeys: String, CodingKey {
        case data
        case studyDays = "studyDays"
        case dailyStudyHours = "dailyStudyHours"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let dataContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .data) {
            studyDays = try? dataContainer.decodeIfPresent([Int].self, forKey: .studyDays)
            dailyStudyHours = try? dataContainer.decodeIfPresent(Float.self, forKey: .dailyStudyHours)
        } else {
            studyDays = try? container.decodeIfPresent([Int].self, forKey: .studyDays)
            dailyStudyHours = try? container.decodeIfPresent(Float.self, forKey: .dailyStudyHours)
        }
    }
}
