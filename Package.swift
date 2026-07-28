// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-server-static",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Server Static",
            targets: ["Server Static"]
        )
    ],
    targets: [
        .target(name: "Server Static"),
        .testTarget(
            name: "Server Static Tests",
            dependencies: ["Server Static"]
        )
    ],
    swiftLanguageModes: [.v6]
)
