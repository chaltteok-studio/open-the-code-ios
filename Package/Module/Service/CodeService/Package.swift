// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CodeService",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "CodeService",
            targets: ["CodeService"])
    ],
    dependencies: [
        .package(path: "../Service"),
        .package(path: "../UserService")
    ],
    targets: [
        .target(
            name: "CodeService",
            dependencies: [
                "Service",
                "UserService"
            ]
        ),
        .testTarget(
            name: "CodeServiceTests",
            dependencies: ["CodeService"]
        )
    ]
)
