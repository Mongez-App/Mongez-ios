// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Preferences",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Preferences",
            targets: ["Preferences"]),
    ],
    dependencies: [.package(path: "../Common")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Preferences",
            dependencies: [
                .product(name: "Common",package: "Common")]
        ),

        .testTarget(
            name: "PreferencesTests",
            dependencies: ["Preferences"]),
    ]
)
