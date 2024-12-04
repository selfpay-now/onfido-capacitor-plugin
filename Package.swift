// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SelfpaynowOnfido",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SelfpaynowOnfido",
            targets: ["SelfPayOnfidoPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "SelfPayOnfidoPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/SelfPayOnfidoPlugin"),
        .testTarget(
            name: "SelfPayOnfidoPluginTests",
            dependencies: ["SelfPayOnfidoPlugin"],
            path: "ios/Tests/SelfPayOnfidoPluginTests")
    ]
)