// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BSNetworkKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "BSNetworkKit-Internal",
            targets: ["BSNetworkKit"]
        ),
    ],
    targets: [
        .target(
            name: "BSNetworkKit",
            path: "Sources"
        ),
        .testTarget(
            name: "BSNetworkKitTests",
            dependencies: ["BSNetworkKit"],
            path: "Tests"
        ),
    ]
)
