// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BSSwiftUI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "BSSwiftUI-Internal",
            targets: ["BSSwiftUI"]
        ),
    ],
    dependencies: [
        .package(path: "../BSCoreKit")
    ],
    targets: [
        .target(
            name: "BSSwiftUI",
            dependencies: [
                .product(name: "BSCoreKit-Internal", package: "BSCoreKit")
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "BSSwiftUITests",
            dependencies: ["BSSwiftUI"],
            path: "Tests"
        ),
    ]
)
