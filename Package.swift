// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Pagepacket",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "GraftCore", targets: ["GraftCore"]),
        .executable(name: "Pagepacket", targets: ["Graft"]),
        .executable(name: "pagepacket-cli", targets: ["GraftCLI"]),
        .executable(name: "pagepacket-behavior-harness", targets: ["GraftBehaviorHarness"])
    ],
    targets: [
        .target(
            name: "GraftCore",
            path: "Sources/GraftCore"
        ),
        .executableTarget(
            name: "Graft",
            dependencies: ["GraftCore"],
            path: "Sources/Graft",
            resources: [
                .copy("Resources")
            ]
        ),
        .executableTarget(
            name: "GraftCLI",
            dependencies: ["GraftCore"],
            path: "Sources/GraftCLI"
        ),
        .executableTarget(
            name: "GraftBehaviorHarness",
            dependencies: ["GraftCore"],
            path: "Sources/GraftBehaviorHarness"
        ),
        .testTarget(
            name: "GraftCoreTests",
            dependencies: ["GraftCore"],
            path: "Tests/GraftCoreTests"
        )
    ]
)
