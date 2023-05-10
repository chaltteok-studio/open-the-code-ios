// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Remote",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Remote",
            targets: ["Remote"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/wlsdms0122/RVB.git", exact: "1.1.0"),
        .package(url: "https://github.com/wlsdms0122/Reducer.git", exact: "1.3.1"),
        .package(url: "https://github.com/wlsdms0122/Compose.git", exact: "1.2.1"),
        .package(url: "https://github.com/wlsdms0122/Logger.git", exact: "1.0.0"),
        .package(url: "https://github.com/wlsdms0122/Validator.git", exact: "1.0.3"),
        .package(url: "https://github.com/wlsdms0122/Network.git", exact: "1.1.1"),
        .package(url: "https://github.com/wlsdms0122/Storage.git", exact: "1.0.2"),
        .package(url: "https://github.com/wlsdms0122/Route.git", exact: "1.3.0"),
        .package(url: "https://github.com/wlsdms0122/Deeplinker.git", exact: "1.1.1"),
        .package(url: "https://github.com/wlsdms0122/JSToast.git", exact: "2.6.5"),
        .package(url: "https://github.com/chaltteok-studio/ChapssalKit-iOS.git", exact: "1.0.7"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", exact: "4.1.2"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", exact: "10.3.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "10.8.0")
    ],
    targets: [
        .target(
            name: "Remote",
            dependencies: [
                
            ]
        )
    ]
)
