// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Payment",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Payment",
            targets: ["Payment"]),
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.3")
    ],
    targets: [
        .target(
            name: "Payment",
            dependencies: [
                .product(name: "Common", package: "Common"),
                .product(name: "Swinject-Dynamic", package: "Swinject"),
                "PaymobSDK"
            ]
        ),
        .binaryTarget(
            name: "PaymobSDK",
            path: "Frameworks/PaymobSDK.xcframework"
        ),
        .testTarget(
            name: "PaymentTests",
            dependencies: ["Payment"]),
    ]
)
