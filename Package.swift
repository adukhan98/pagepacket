// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Pagepacket",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "Pagepacket", targets: ["Graft"]),
        .executable(name: "pagepacket-cli", targets: ["GraftCLI"])
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
