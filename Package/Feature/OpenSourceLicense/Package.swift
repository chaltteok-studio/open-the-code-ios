// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OpenSourceLicense",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "OpenSourceLicense",
            targets: ["OpenSourceLicense"]
        )
    ],
    dependencies: [
        .package(path: "../Feature")
    ],
    targets: [
        .target(
            name: "OpenSourceLicense",
            dependencies: [
                "Feature"
            ]
        )
    ]
)
