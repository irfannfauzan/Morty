// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MortyCore",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "MortyCore", targets: ["MortyCore"])
    ],
    targets: [
        .target(name: "MortyCore")
    ]
)
