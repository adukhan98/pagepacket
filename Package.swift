// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Graft",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "Graft", targets: ["Graft"]),
        .executable(name: "graft-cli", targets: ["GraftCLI"])
    ],
    targets: [
        .executableTarget(
            name: "Graft",
            path: "Sources/Graft",
            resources: [
                .copy("Resources")
            ]
        ),
        .executableTarget(
            name: "GraftCLI",
            path: "Sources/GraftCLI"
        )
    ]
)
