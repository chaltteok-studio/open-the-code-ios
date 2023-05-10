// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MyCodes",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MyCodes",
            targets: ["MyCodes"]
        )
    ],
    dependencies: [
        .package(path: "../../Module/Service/CodeService"),
        .package(path: "../Feature"),
        .package(path: "../Room")
    ],
    targets: [
        .target(
            name: "MyCodes",
            dependencies: [
                "CodeService",
                "Feature",
                "Room"
            ]
        )
    ]
)
