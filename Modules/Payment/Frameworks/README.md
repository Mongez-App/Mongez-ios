# PaymobSDK.xcframework

This directory must contain `PaymobSDK.xcframework`, downloaded manually from your Paymob merchant dashboard
(Developers → Mobile SDKs → iOS SDK → Manual Installation). It is not checked into this change because it
requires your own Paymob account credentials to obtain.

Package.swift references it via a local `.binaryTarget(name: "PaymobSDK", path: "Frameworks/PaymobSDK.xcframework")`,
so package resolution will fail until the framework is actually placed here.
