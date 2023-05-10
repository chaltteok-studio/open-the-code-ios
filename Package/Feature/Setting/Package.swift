// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Setting",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Setting",
            targets: ["Setting"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", .upToNextMajor(from: "10.3.0")),
        .package(path: "../../Module/Service/CodeService"),
        .package(path: "../Feature"),
        .package(path: "../Notice"),
        .package(path: "../MyCodes"),
        .package(path: "../BlockedCodes"),
        .package(path: "../OpenSourceLicense")
    ],
    targets: [
        .target(
            name: "Setting",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                "CodeService",
                "Feature",
                "Notice",
                "MyCodes",
                "BlockedCodes",
                "OpenSourceLicense"
            ]
        )
    ]
)
