// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "Pagepacket",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "Pagepacket", targets: ["Pagepacket"]),
        .executable(name: "pagepacket-cli", targets: ["PagepacketCLI"])
    ],
    targets: [
        .executableTarget(
            name: "Pagepacket",
            path: "Sources/Pagepacket",
            resources: [
                .copy("Resources")
            ]
        ),
        .executableTarget(
            name: "PagepacketCLI",
            path: "Sources/PagepacketCLI"
        )
    ]
)
