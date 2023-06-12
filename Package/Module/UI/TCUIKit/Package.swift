// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TCUIKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TCUIKit",
            targets: ["TCUIKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", .upToNextMajor(from: "10.3.0")),
        .package(url: "https://github.com/chaltteok-studio/ChapssalKit-iOS.git", .upToNextMajor(from: "1.0.8")),
        .package(path: "../../../Core/Util"),
        .package(path: "../Resource"),
        .package(path: "../../Environment"),
        .package(path: "../../API"),
        .package(path: "../../Service/CodeService")
    ],
    targets: [
        .target(
            name: "TCUIKit",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                "Util",
                .product(name: "ChapssalKit", package: "ChapssalKit-iOS"),
                "Environment",
                "API",
                "Resource",
                "CodeService"
            ]
        )
    ]
)
