// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DemoNetwork",
    platforms: [
        .iOS(.v16),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "DemoNetwork",
            targets: ["DemoNetwork"]
        ),
    ],
    dependencies: [
        .package(path: "../../../Packages/BSNetworkKit")
    ],
    targets: [
        .target(
            name: "DemoNetwork",
            dependencies: [
                .product(name: "BSNetworkKit-Internal", package: "BSNetworkKit")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "DemoNetworkTests",
            dependencies: ["DemoNetwork"],
            path: "Tests"
        ),
    ]
)
