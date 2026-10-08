// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SelfpaynowOnfido",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "SelfpaynowOnfido",
            targets: ["SelfPayOnfidoPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main"),
        // Keep in sync with ENTRUST_IDV_SPM_VERSION in ios/spm_dependency.rb
        .package(url: "https://github.com/entrustCorporation/IdvSdk-iOS", exact: "100.17.0")
    ],
    targets: [
        .target(
            name: "SelfPayOnfidoPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm"),
                .product(name: "EntrustIdv", package: "IdvSdk-iOS"),
                .product(name: "Welcome", package: "IdvSdk-iOS"),
                .product(name: "Consent", package: "IdvSdk-iOS"),
                .product(name: "Document", package: "IdvSdk-iOS"),
                .product(name: "NFC", package: "IdvSdk-iOS"),
                .product(name: "FacePhoto", package: "IdvSdk-iOS"),
                .product(name: "FaceMotion", package: "IdvSdk-iOS"),
                .product(name: "Retry", package: "IdvSdk-iOS")
            ],
            path: "ios/Sources/SelfPayOnfidoPlugin"),
        .testTarget(
            name: "SelfPayOnfidoPluginTests",
            dependencies: ["SelfPayOnfidoPlugin"],
            path: "ios/Tests/SelfPayOnfidoPluginTests")
    ]
)