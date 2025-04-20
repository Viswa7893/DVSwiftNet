// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "DVSwiftNet",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "DVSwiftNet",
            targets: ["DVSwiftNet"]
        ),
    ],
    targets: [
        .target(
            name: "DVSwiftNet",
            dependencies: []
        ),
        .testTarget(
            name: "DVSwiftNetTests",
            dependencies: ["DVSwiftNet"]
        ),
    ]
)
