// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Resource",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Resource",
            targets: ["Resource"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/chaltteok-studio/ChapssalKit-iOS.git", .upToNextMajor(from: "1.0.8"))
    ],
    targets: [
        .target(
            name: "Resource",
            dependencies: [
                .product(name: "ChapssalKit", package: "ChapssalKit-iOS")
            ],
            resources: [
                .process("Resource/Font")
            ]
        ),
        .testTarget(
            name: "ResourceTests",
            dependencies: [
                "Resource"
            ]
        )
    ]
)
