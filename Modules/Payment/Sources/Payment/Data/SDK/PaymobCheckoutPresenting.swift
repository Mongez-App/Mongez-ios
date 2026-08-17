import UIKit

// The seam between Payment's own ViewModel/tests and the vendor SDK — nothing outside
// PaymobSDKAdapter.swift needs to `import PaymobSDK` or reference its concrete types.
public enum PaymobCheckoutResult {
    case accepted(transactionDetails: [String: Any])
    case rejected(message: String)
    case pending
    case cancelled
}

public struct PaymobCheckoutCustomization {
    public var appName: String?
    public var appIcon: UIImage?
    public var buttonBackgroundColor: UIColor?
    public var buttonTextColor: UIColor?
    public var showSaveCard: Bool
    public var saveCardDefault: Bool

    public init(
        appName: String? = nil,
        appIcon: UIImage? = nil,
        buttonBackgroundColor: UIColor? = nil,
        buttonTextColor: UIColor? = nil,
        showSaveCard: Bool = false,
        saveCardDefault: Bool = false
    ) {
        self.appName = appName
        self.appIcon = appIcon
        self.buttonBackgroundColor = buttonBackgroundColor
        self.buttonTextColor = buttonTextColor
        self.showSaveCard = showSaveCard
        self.saveCardDefault = saveCardDefault
    }
}

public protocol PaymobCheckoutPresenting {
    func presentCheckout(
        from viewController: UIViewController,
        publicKey: String,
        clientSecret: String,
        customization: PaymobCheckoutCustomization,
        onResult: @escaping (PaymobCheckoutResult) -> Void
    )
}
