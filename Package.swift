// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-server-static",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Server Static",
            targets: ["Server Static"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-server.git", branch: "main")
    ],
    targets: [
        .target(
            name: "Server Static",
            dependencies: [
                .product(name: "Server", package: "swift-server")
            ]
        ),
        .testTarget(
            name: "Server Static Tests",
            dependencies: ["Server Static"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
