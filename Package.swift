// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "Presentation",
            targets: ["Presentation"]),
    ],
    dependencies: [
        .package(name: "Common", url: "https://github.com/w9i/Common", from: "1.0.0"),
        .package(name: "Domain", url: "https://github.com/w9i/Domain1", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Presentation",
            dependencies: ["Common", "Domain"]),
        .testTarget(
            name: "PresentationTests",
            dependencies: ["Presentation"]),
    ]
)
