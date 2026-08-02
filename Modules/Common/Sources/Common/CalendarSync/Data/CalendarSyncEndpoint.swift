import Foundation

enum CalendarSyncEndpoint: EndPoint {
    case syncEvents(events: [CalendarEventDto])

    var baseURL: String { "https://api-gateway-production-3fd0.up.railway.app/api/v1" }

    var path: String {
        switch self {
        case .syncEvents: return "/users/me/calendar-events"
        }
    }

    var method: HTTPMethod { .post }

    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json", "Accept": "application/json"]
        if let token = UserDefaults.standard.string(forKey: "main_token") {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }

    var body: Data? {
        switch self {
        case .syncEvents(let events):
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            return try? encoder.encode(CalendarSyncRequestBody(events: events))
        }
    }
}

private struct CalendarSyncRequestBody: Encodable {
    let events: [CalendarEventDto]
}
