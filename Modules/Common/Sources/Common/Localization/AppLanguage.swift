import SwiftUI

public enum AppLanguage: String, CaseIterable {
    case english = "EN"
    case arabic = "AR"

    public var locale: Locale {
        switch self {
        case .english: return Locale(identifier: "en")
        case .arabic: return Locale(identifier: "ar")
        }
    }

    public var layoutDirection: LayoutDirection {
        switch self {
        case .english: return .leftToRight
        case .arabic: return .rightToLeft
        }
    }

    /// Matches the free-form language strings already sent to/received from the backend
    /// (e.g. `UserProfile.language`, the `updateProfile` request body).
    public init(backendValue: String?) {
        switch backendValue?.lowercased() {
        case "arabic", "ar":
            self = .arabic
        default:
            self = .english
        }
    }

    public var backendValue: String {
        switch self {
        case .english: return "English"
        case .arabic: return "Arabic"
        }
    }
}
