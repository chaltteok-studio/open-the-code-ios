// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserService",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "UserService",
            targets: ["UserService"])
    ],
    dependencies: [
        .package(path: "../Service")
    ],
    targets: [
        .target(
            name: "UserService",
            dependencies: [
                "Service"
            ]
        ),
        .testTarget(
            name: "UserServiceTests",
            dependencies: ["UserService"]
        )
    ]
)
