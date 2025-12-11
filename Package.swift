// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BSKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Expose all sub-packages as separate products for independent imports
        .library(name: "BSCoreKit", targets: ["BSCoreKitWrapper"]),
        .library(name: "BSUIKit", targets: ["BSUIKitWrapper"]),
        .library(name: "BSSwiftUI", targets: ["BSSwiftUIWrapper"]),
        .library(name: "BSNetworkKit", targets: ["BSNetworkKitWrapper"]),
    ],
    dependencies: [
        .package(path: "Packages/BSCoreKit"),
        .package(path: "Packages/BSUIKit"),
        .package(path: "Packages/BSSwiftUI"),
        .package(path: "Packages/BSNetworkKit"),
    ],
    targets: [
        // Wrapper targets that re-export the sub-packages
        .target(
            name: "BSCoreKitWrapper",
            dependencies: [
                .product(name: "BSCoreKit-Internal", package: "BSCoreKit")
            ],
            path: "Sources/BSCoreKitWrapper"
        ),
        .target(
            name: "BSUIKitWrapper",
            dependencies: [
                .product(name: "BSUIKit-Internal", package: "BSUIKit")
            ],
            path: "Sources/BSUIKitWrapper"
        ),
        .target(
            name: "BSSwiftUIWrapper",
            dependencies: [
                .product(name: "BSSwiftUI-Internal", package: "BSSwiftUI")
            ],
            path: "Sources/BSSwiftUIWrapper"
        ),
        .target(
            name: "BSNetworkKitWrapper",
            dependencies: [
                .product(name: "BSNetworkKit-Internal", package: "BSNetworkKit")
            ],
            path: "Sources/BSNetworkKitWrapper"
        ),
    ]
)
