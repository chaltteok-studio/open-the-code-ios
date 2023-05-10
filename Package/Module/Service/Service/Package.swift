// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Service",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Service",
            targets: ["Service"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/wlsdms0122/Logger.git", .upToNextMajor(from: "1.0.0")),
        .package(path: "../../../Core/Util"),
        .package(path: "../../Environment"),
        .package(path: "../../API"),
        .package(path: "../../Store")
    ],
    targets: [
        .target(
            name: "Service",
            dependencies: [
                "Logger",
                "Util",
                "Environment",
                "API",
                "Store"
            ]
        )
    ]
)
