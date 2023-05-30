// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AnimationUtils",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AnimationUtils",
            targets: ["AnimationUtils"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AnimationUtils",
            dependencies: []),
    ]
)
