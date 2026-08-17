import Foundation

// Subscription status (plan type, purchase/expiry dates) is non-secret local state, so a plain
// UserDefaults wrapper is used here rather than a Keychain copy. Keys are scoped by "current_user_id"
// (the same UserDefaults key Auth/Courses/CourseDetails/AIStudyRoom already use to identify the
// logged-in user) — without this, every account on the device would share one subscription record.
public class SubscriptionLocalStore {
    private enum Keys {
        static let planType = "payment_selected_plan_type"
        static let purchaseDate = "payment_purchase_date"
        static let expiryDate = "payment_expiry_date"
    }

    private let defaults: UserDefaults

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    private func scopedKey(_ base: String) -> String {
        let userId = defaults.string(forKey: "current_user_id") ?? "anonymous"
        return "\(base)_\(userId)"
    }

    public func save(planType: PlanType, purchaseDate: Date, expiryDate: Date) {
        defaults.set(planType.rawValue, forKey: scopedKey(Keys.planType))
        defaults.set(purchaseDate.timeIntervalSince1970, forKey: scopedKey(Keys.purchaseDate))
        defaults.set(expiryDate.timeIntervalSince1970, forKey: scopedKey(Keys.expiryDate))
    }

    public func loadActiveSubscription() -> ActiveSubscription? {
        guard
            let rawType = defaults.string(forKey: scopedKey(Keys.planType)),
            let planType = PlanType(rawValue: rawType),
            defaults.object(forKey: scopedKey(Keys.purchaseDate)) != nil,
            defaults.object(forKey: scopedKey(Keys.expiryDate)) != nil
        else {
            return nil
        }

        let purchaseDate = Date(timeIntervalSince1970: defaults.double(forKey: scopedKey(Keys.purchaseDate)))
        let expiryDate = Date(timeIntervalSince1970: defaults.double(forKey: scopedKey(Keys.expiryDate)))
        return ActiveSubscription(planType: planType, purchaseDate: purchaseDate, expiryDate: expiryDate)
    }

    public func clear() {
        defaults.removeObject(forKey: scopedKey(Keys.planType))
        defaults.removeObject(forKey: scopedKey(Keys.purchaseDate))
        defaults.removeObject(forKey: scopedKey(Keys.expiryDate))
    }
}
