import Foundation

public struct CalendarEventEntity: Equatable {
    public let externalId: String
    public let title: String
    public let startDate: Date
    public let endDate: Date
    public let calendarName: String?

    public init(externalId: String, title: String, startDate: Date, endDate: Date, calendarName: String?) {
        self.externalId = externalId
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.calendarName = calendarName
    }
}
