import Foundation

public struct TeamEvent: Identifiable, Equatable {
    public let id: String
    public let courseName: String
    public let eventType: String
    public let eventDate: String
    public let daysLeft: Int
    
    public init(id: String, courseName: String, eventType: String, eventDate: String, daysLeft: Int) {
        self.id = id
        self.courseName = courseName
        self.eventType = eventType
        self.eventDate = eventDate
        self.daysLeft = daysLeft
    }
}
