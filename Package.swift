// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "RBChat",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "RBChat", targets: ["RBChat"])
    ],
    dependencies: [
        .package(url: "https://github.com/MessageKit/MessageKit.git", .upToNextMajor(from: "5.0.0"))
    ],
    targets: [
        .target(name: "RBChat", dependencies: ["MessageKit"], path: "RBChat")
    ]
)
