// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Graft",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "GraftCore", targets: ["GraftCore"]),
        .executable(name: "Graft", targets: ["Graft"]),
        .executable(name: "graft-cli", targets: ["GraftCLI"]),
        .executable(name: "graft-behavior-harness", targets: ["GraftBehaviorHarness"])
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
