//
//  SessionManager.swift
//  Common
//
//  Created by Extern Dev
//

import Foundation

public enum SessionManager {

    private enum Keys {
        static let token = "main_token"
        static let userId = "current_user_id"
        static let displayName = "user_display_name"
    }

    public static var sessionToken: String? {
        get { UserDefaults.standard.string(forKey: Keys.token) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.token) }
    }

    public static var hasActiveSession: Bool {
        guard let token = sessionToken, !token.isEmpty else { return false }
        return true
    }

    public static var userId: String? {
        get { UserDefaults.standard.string(forKey: Keys.userId) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.userId) }
    }

    public static var displayName: String? {
        get { UserDefaults.standard.string(forKey: Keys.displayName) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.displayName) }
    }

    public static var authorizationHeader: [String: String]? {
        guard let token = sessionToken, !token.isEmpty else { return nil }
        return ["Authorization": "Bearer \(token)"]
    }

    public static func clear() {
        sessionToken = nil
        userId = nil
    }
}
