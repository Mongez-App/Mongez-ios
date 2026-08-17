import UIKit
import PaymobSDK

// The only file in this module allowed to import the vendor SDK. Will not compile until
// PaymobSDK.xcframework is actually present at Modules/Payment/Frameworks/ (see Frameworks/README.md) —
// cross-check this file's API usage (PaymobSDK(), PaymobSDKDelegate, paymobSDKCustomization,
// presentPayVC(VC:PublicKey:ClientSecret:)) against the exact SDK version you download, since Paymob's
// docs may have moved on since this was written.
public final class PaymobSDKAdapter: NSObject, PaymobCheckoutPresenting {
    private var paymob: PaymobSDK?
    private var onResult: ((PaymobCheckoutResult) -> Void)?

    public override init() {
        super.init()
    }

    public func presentCheckout(
        from viewController: UIViewController,
        publicKey: String,
        clientSecret: String,
        customization: PaymobCheckoutCustomization,
        onResult: @escaping (PaymobCheckoutResult) -> Void
    ) {
        self.onResult = onResult

        let paymob = PaymobSDK()
        paymob.delegate = self
        self.paymob = paymob

        if let appName = customization.appName {
            paymob.paymobSDKCustomization.appName = appName
        }
        if let appIcon = customization.appIcon {
            paymob.paymobSDKCustomization.appIcon = appIcon
        }
        if let buttonBackgroundColor = customization.buttonBackgroundColor {
            paymob.paymobSDKCustomization.buttonBackgroundColor = buttonBackgroundColor
        }
        if let buttonTextColor = customization.buttonTextColor {
            paymob.paymobSDKCustomization.buttonTextColor = buttonTextColor
        }
        paymob.paymobSDKCustomization.showSaveCard = customization.showSaveCard
        paymob.paymobSDKCustomization.saveCardDefault = customization.saveCardDefault

        do {
            try paymob.presentPayVC(VC: viewController, PublicKey: publicKey, ClientSecret: clientSecret)
        } catch {
            onResult(.rejected(message: error.localizedDescription))
        }
    }
}

extension PaymobSDKAdapter: PaymobSDKDelegate {
    public func transactionAccepted(transactionDetails: [String: Any]) {
        print("[Paymob] transactionAccepted: \(transactionDetails)")
        onResult?(.accepted(transactionDetails: transactionDetails))
    }

    public func transactionRejected(message: String) {
        print("[Paymob] transactionRejected: \(message)")
        onResult?(.rejected(message: message))
    }

    public func transactionPending() {
        print("[Paymob] transactionPending")
        onResult?(.pending)
    }

    public func transactionCancelled() {
        print("[Paymob] transactionCancelled")
        onResult?(.cancelled)
    }
}
