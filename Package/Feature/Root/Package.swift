// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Root",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Root",
            targets: ["Root"]
        )
    ],
    dependencies: [
        .package(path: "../Feature"),
        .package(path: "../Launch"),
        .package(path: "../Main")
    ],
    targets: [
        .target(
            name: "Root",
            dependencies: [
                "Feature",
                "Launch",
                "Main"
            ]
        )
    ]
)
