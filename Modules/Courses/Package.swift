// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "Courses",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Courses",
            targets: ["Courses"]),
    ],
    dependencies: [
        .package(path: "../Common"),
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.8.0")
    ],
    targets: [
        .target(
            name: "Courses",
            dependencies: [
                .product(name: "Common", package: "Common"),
                .product(name: "Swinject-Dynamic", package: "Swinject")
            ]),
        .testTarget(
            name: "CoursesTests",
            dependencies: ["Courses"]),
    ]
)

