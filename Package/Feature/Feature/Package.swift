// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Feature",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Feature",
            targets: ["Feature"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/wlsdms0122/RVB.git", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/wlsdms0122/Reducer.git", .upToNextMajor(from: "1.3.1")),
        .package(url: "https://github.com/wlsdms0122/Compose.git", .upToNextMajor(from: "1.2.1")),
        .package(url: "https://github.com/wlsdms0122/Logger.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/wlsdms0122/Route.git", .upToNextMajor(from: "1.3.0")),
        .package(url: "https://github.com/wlsdms0122/Deeplinker.git", .upToNextMajor(from: "1.1.1")),
        .package(url: "https://github.com/wlsdms0122/JSToast.git", .upToNextMajor(from: "2.6.5")),
        .package(path: "../../Core/Util"),
        .package(path: "../../Module/Environment"),
        .package(path: "../../Module/UI/TCUIKit")
    ],
    targets: [
        .target(
            name: "Feature",
            dependencies: [
                "RVB",
                "Reducer",
                "Compose",
                "Logger",
                "Route",
                "Deeplinker",
                "JSToast",
                "Util",
                "Environment",
                "TCUIKit"
            ]
        )
    ]
)
