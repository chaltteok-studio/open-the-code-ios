// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "App",
            targets: ["App"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/wlsdms0122/Logger.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", .upToNextMajor(from: "10.3.0")),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.8.0")),
        .package(path: "../Module/Environment"),
        .package(path: "../Module/UI/TCUIKit"),
        .package(path: "../Feature/Root")
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                "Logger",
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                "Environment",
                "TCUIKit",
                "Root"
            ]
        )
    ]
)
