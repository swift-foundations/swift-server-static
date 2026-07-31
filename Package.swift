// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-server-static",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
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
