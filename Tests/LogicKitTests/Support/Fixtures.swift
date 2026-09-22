import Foundation

/// Fixtures live in Tests/Fixtures (outside the target), found relative to this file.
enum Fixtures {
    static let root = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()   // Support
        .deletingLastPathComponent()   // LogicKitTests
        .deletingLastPathComponent()   // Tests
        .appendingPathComponent("Fixtures")

    static func url(_ relative: String) -> URL {
        root.appendingPathComponent(relative)
    }
}
