// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Notice",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Notice",
            targets: ["Notice"]
        )
    ],
    dependencies: [
        .package(path: "../../Module/Service/AppService"),
        .package(path: "../Feature"),
        .package(path: "../Web")
    ],
    targets: [
        .target(
            name: "Notice",
            dependencies: [
                "AppService",
                "Feature",
                "Web"
            ]
        )
    ]
)
