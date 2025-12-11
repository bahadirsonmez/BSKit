// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BSUIKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "BSUIKit-Internal",
            targets: ["BSUIKit"]
        ),
    ],
    dependencies: [
        .package(path: "../BSCoreKit")
    ],
    targets: [
        .target(
            name: "BSUIKit",
            dependencies: [
                .product(name: "BSCoreKit-Internal", package: "BSCoreKit")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "BSUIKitTests",
            dependencies: ["BSUIKit"],
            path: "Tests"
        ),
    ]
)
