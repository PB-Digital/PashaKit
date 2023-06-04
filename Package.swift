// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

public let package = Package(
    name: "PashaKit",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "PashaKit", targets: ["PashaKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/RedMadRobot/input-mask-ios.git", exact: "6.1.0")
    ],
    targets: [
        .target(name: "PashaKit", dependencies: [.product(name: "InputMask", package: "input-mask-ios")], path: "Sources"),
        .testTarget(name: "PashaKitTests", dependencies: ["PashaKit"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
