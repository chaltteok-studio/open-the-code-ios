// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Environment",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Environment",
            targets: ["Environment"]
        )
    ],
    dependencies: [
        .package(path: "../../Core/Util"),
        .package(path: "../UI/Resource")
    ],
    targets: [
        .target(
            name: "Environment",
            dependencies: [
                "Util",
                "Resource"
            ]
        )
    ]
)
