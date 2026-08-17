import Foundation

/// Owns the app's active language/layout direction, sourced from the same
/// `selected_language` UserDefaults key already shared by Profile and Auth.
/// Applied at the app root via `.environment(\.locale, ...)` / `.environment(\.layoutDirection, ...)`
/// so switching it from the Profile language picker re-renders the whole app immediately.
@MainActor
public final class LocalizationManager: ObservableObject {
    public static let shared = LocalizationManager()

    private static let userDefaultsKey = "selected_language"

    @Published public private(set) var language: AppLanguage

    private init() {
        let stored = UserDefaults.standard.string(forKey: Self.userDefaultsKey) ?? AppLanguage.english.rawValue
        language = AppLanguage(rawValue: stored) ?? .english
    }

    public func setLanguage(_ language: AppLanguage) {
        guard self.language != language else { return }
        self.language = language
        UserDefaults.standard.set(language.rawValue, forKey: Self.userDefaultsKey)
    }
}
