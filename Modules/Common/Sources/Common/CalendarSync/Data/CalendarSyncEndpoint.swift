import Foundation

enum CalendarSyncEndpoint: EndPoint {
    case syncEvents(events: [CalendarEventDto])
    case getStatus
    case updateFlags(calendarConnected: Bool, calendarSynced: Bool)

    var baseURL: String {
        switch self {
        case .syncEvents:
            return "https://api-gateway-production-5110.up.railway.app/api/v1"
        case .getStatus, .updateFlags:
            return "https://api-gateway-production-5110.up.railway.app/api/v1"
        }
    }

    var path: String {
        switch self {
        case .syncEvents: return "/calendar/events"
        case .getStatus, .updateFlags: return "/auth/calendar-sync"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .syncEvents: return .post
        case .getStatus: return .get
        case .updateFlags: return .patch
        }
    }

    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json", "Accept": "application/json"]
        if let token = UserDefaults.standard.string(forKey: "main_token") {
            headers["Authorization"] = "Bearer \(token)"
        }
        if let userId = UserDefaults.standard.string(forKey: "current_user_id") {
            headers["X-User-Id"] = userId
        }
        return headers
    }

    var body: Data? {
        switch self {
        case .syncEvents(let events):
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return try? encoder.encode(CalendarSyncRequestBody(events: events))
        case .getStatus:
            return nil
        case .updateFlags(let calendarConnected, let calendarSynced):
            return try? JSONEncoder().encode(
                UpdateCalendarSyncFlagsBody(calendarConnected: calendarConnected, calendarSynced: calendarSynced)
            )
        }
    }
}

private struct CalendarSyncRequestBody: Encodable {
    let events: [CalendarEventDto]
}

private struct UpdateCalendarSyncFlagsBody: Encodable {
    let calendarConnected: Bool
    let calendarSynced: Bool

    enum CodingKeys: String, CodingKey {
        case calendarConnected = "calendar_connected"
        case calendarSynced = "calendar_synced"
    }
}
