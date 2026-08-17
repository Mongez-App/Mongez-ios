import Foundation

// Template — copy this file to PaymentSecrets.swift (gitignored, sits alongside this file) and fill
// in your own Paymob test-account credentials before building.
//
// secretKey / publicKey: Dashboard → Settings → API Keys (Test mode toggle on) → View next to
//   Secret Key / Public Key.
// apiKey: Dashboard → Settings → API Keys → View next to API Key. Same value for Test and Live —
//   only used for the Transaction Inquiry fallback (verifying a transaction after a non-definitive
//   SDK result), keep it out of source control.
// cardIntegrationID / walletIntegrationID: Dashboard → Settings → Payment Integrations (Test mode).
enum PaymentSecrets {
    static let secretKey = "egy_sk_test_REPLACE_ME"
    static let publicKey = "egy_pk_test_REPLACE_ME"
    static let apiKey = "REPLACE_ME_API_KEY"
    static let cardIntegrationID = 0
    static let walletIntegrationID = 0
}
