import XCTest
import LogicKit

enum LiveLedger {
    static let url = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        .appendingPathComponent("Sources/LogicKit/Resources/ledger.json")

    /// Call as the last line of a live test, after all assertions (continueAfterFailure = false).
    static func pass(_ kind: NodeKind, _ name: String) throws {
        let cap = try XCTUnwrap(Grammar.find(kind, name))
        var l = try Ledger.load(url)
        l.record(cap, version: LogicApp.version() ?? "unknown", date: ISO8601DateFormatter().string(from: Date()))
        try l.write(to: url)
    }
}

class LiveCase: XCTestCase {
    override func setUp() { continueAfterFailure = false }
    func env(_ root: LiveAXRoot) -> RecipeEnv { RecipeEnv(root: root, locale: .en, logicPID: root.pid) }
}
