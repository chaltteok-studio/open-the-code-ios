// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppService",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "AppService",
            targets: ["AppService"])
    ],
    dependencies: [
        .package(path: "../Service")
    ],
    targets: [
        .target(
            name: "AppService",
            dependencies: [
                "Service"
            ]
        ),
        .testTarget(
            name: "AppServiceTests",
            dependencies: ["AppService"]
        )
    ]
)
