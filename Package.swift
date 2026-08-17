// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-server-static",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27"),
        .visionOS("27"),
    ],
    products: [
        .library(
            name: "Server Static",
            targets: ["Server Static"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-server.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Server Static",
            dependencies: [
                .product(name: "Server", package: "swift-server"),
            ]
        ),
        .testTarget(
            name: "Server Static Tests",
            dependencies: ["Server Static"]
        )
    ],
    swiftLanguageModes: [.v6]
)
