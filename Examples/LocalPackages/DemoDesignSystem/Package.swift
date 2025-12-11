// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DemoDesignSystem",
    platforms: [
        .iOS(.v16),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "DemoDesignSystem",
            targets: ["DemoDesignSystem"]
        ),
    ],
    targets: [
        .target(
            name: "DemoDesignSystem",
            path: "Sources"
        ),
        .testTarget(
            name: "DemoDesignSystemTests",
            dependencies: ["DemoDesignSystem"],
            path: "Tests"
        ),
    ]
)
