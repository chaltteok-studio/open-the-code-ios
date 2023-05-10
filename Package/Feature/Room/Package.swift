// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Room",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Room",
            targets: ["Room"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", .upToNextMajor(from: "10.3.0")),
        .package(path: "../../Module/Service/UserService"),
        .package(path: "../../Module/Service/CodeService"),
        .package(path: "../Feature")
    ],
    targets: [
        .target(
            name: "Room",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                "Feature",
                "UserService",
                "CodeService"
            ]
        )
    ]
)
