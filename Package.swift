// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LogicProMCP",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "LogicProMCP", targets: ["LogicMCP"]),
        .library(name: "LogicKit", targets: ["LogicKit"]),
        .executable(name: "logic-ax-dump", targets: ["logic-ax-dump"]),
        .executable(name: "logic-probe", targets: ["logic-probe"]),
    ],
    dependencies: [
        .package(url: "https://github.com/modelcontextprotocol/swift-sdk.git", from: "0.12.1"),
    ],
    targets: [
        .target(
            name: "LogicKit",
            path: "Sources/LogicKit",
            resources: [.copy("Resources/ledger.json")],
            linkerSettings: [
                .linkedFramework("CoreMIDI"),
                .linkedFramework("ApplicationServices"),
                .linkedFramework("CoreGraphics"),
                .linkedFramework("AppKit"),
                .linkedFramework("Network"),
            ]
        ),
        .executableTarget(
            name: "LogicMCP",
            dependencies: ["LogicKit", .product(name: "MCP", package: "swift-sdk")],
            path: "Sources/LogicMCP"
        ),
        .executableTarget(
            name: "logic-ax-dump",
            dependencies: ["LogicKit"],
            path: "Sources/logic-ax-dump"
        ),
        .executableTarget(
            name: "logic-probe",
            dependencies: ["LogicKit"],
            path: "Sources/logic-probe",
            linkerSettings: [.linkedFramework("CoreMIDI")]
        ),
        .testTarget(
            name: "LogicMCPTests",
            dependencies: ["LogicMCP", "LogicKit"],
            path: "Tests/LogicMCPTests"
        ),
        .testTarget(
            name: "LogicKitTests",
            dependencies: ["LogicKit"],
            path: "Tests/LogicKitTests"
        ),
        .testTarget(
            name: "LogicLiveTests",
            dependencies: ["LogicKit"],
            path: "Tests/LogicLiveTests"
        ),
    ]
)
