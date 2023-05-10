// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Main",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Main",
            targets: ["Main"]
        )
    ],
    dependencies: [
        .package(path: "../Feature"),
        .package(path: "../EnterCode"),
        .package(path: "../CreateCode"),
        .package(path: "../Setting")
    ],
    targets: [
        .target(
            name: "Main",
            dependencies: [
                "Feature",
                "EnterCode",
                "CreateCode",
                "Setting"
            ]
        )
    ]
)
