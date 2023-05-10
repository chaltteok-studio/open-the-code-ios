// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CreateCode",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "CreateCode",
            targets: ["CreateCode"]
        )
    ],
    dependencies: [
        .package(path: "../../Module/Servide/CodeService"),
        .package(path: "../Feature")
    ],
    targets: [
        .target(
            name: "CreateCode",
            dependencies: [
                "CodeService",
                "Feature"
            ]
        )
    ]
)
