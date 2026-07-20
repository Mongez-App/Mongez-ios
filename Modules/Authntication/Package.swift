// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Authntication",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Authntication",
            targets: ["Authntication"]),
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.19.0"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "7.1.0") 
    ],
    targets: [
        .target(
            name: "Authntication",
            dependencies: [
                .product(name: "Common", package: "Common"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS")
            ]
        ),
        .testTarget(
            name: "AuthnticationTests",
            dependencies: ["Authntication"]),
    ]
)
