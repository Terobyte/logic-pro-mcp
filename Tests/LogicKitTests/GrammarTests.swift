import XCTest
@testable import LogicKit

final class GrammarTests: XCTestCase {
    func testAdvertisedNeedsLedgerRowForMinor() throws {
        let mute = try XCTUnwrap(Grammar.find(.track, "mute"))
        var l = Ledger(entries: [])
        XCTAssertTrue(Grammar.advertised(ledger: l, logicMinor: "11.2").isEmpty)
        l.record(mute, version: "11.2.1", date: "2026-09-21")
        XCTAssertEqual(Grammar.advertised(ledger: l, logicMinor: "11.2").map(\.key), ["track.mute"])
        XCTAssertTrue(Grammar.advertised(ledger: l, logicMinor: "11.3").isEmpty)
        XCTAssertEqual(Grammar.advertised(ledger: l, logicMinor: nil).map(\.key), ["track.mute"]) // Logic not running → newest minor
        l.record(mute, version: "11.2.2", date: "2026-09-22")
        XCTAssertEqual(l.entries.count, 1)
    }

    func testBundledLedgerReferencesKnownCapabilities() {
        for e in Ledger.bundled().entries { XCTAssertNotNil(Grammar.all.first { $0.key == e.capability }, e.capability) }
    }

    func testIndexIsCompact() {
        let idx = Grammar.index(Grammar.all)
        XCTAssertTrue(idx.contains("track: read, mute=on|off"))
        XCTAssertLessThanOrEqual(TokenEstimate.count(idx), 150)
        XCTAssertTrue(Grammar.schema(.track, caps: Grammar.all).contains("logic_set track:N/mute"))
    }
}
