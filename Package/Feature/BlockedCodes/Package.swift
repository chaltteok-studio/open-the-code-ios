// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BlockedCodes",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "BlockedCodes",
            targets: ["BlockedCodes"]
        )
    ],
    dependencies: [
        .package(path: "../../Module/Service/CodeService"),
        .package(path: "../Feature")
    ],
    targets: [
        .target(
            name: "BlockedCodes",
            dependencies: [
                "CodeService",
                "Feature"
            ]
        )
    ]
)
