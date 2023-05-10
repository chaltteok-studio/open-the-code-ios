// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Web",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Web",
            targets: ["Web"]
        )
    ],
    dependencies: [
        .package(path: "../Feature")
    ],
    targets: [
        .target(
            name: "Web",
            dependencies: [
                "Feature"
            ]
        )
    ]
)
