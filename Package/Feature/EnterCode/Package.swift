// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EnterCode",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "EnterCode",
            targets: ["EnterCode"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", .upToNextMajor(from: "10.3.0")),
        .package(path: "../Feature"),
        .package(path: "../Room")
    ],
    targets: [
        .target(
            name: "EnterCode",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                "Feature",
                "Room"
            ]
        )
    ]
)
