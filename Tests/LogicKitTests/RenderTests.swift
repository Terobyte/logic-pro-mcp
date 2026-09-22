import XCTest
@testable import LogicKit

final class RenderTests: XCTestCase {
    func fixtureRoot(_ name: String) throws -> String {
        let r = FixtureAXRoot(try AXFixture.load(Fixtures.url("ax/\(name).json")))
        let tracks = try TrackReader.read(r, .en)
        return TextRenderer.root(project: try ProjectReader.read(r, version: "11.2"), transport: try? TransportReader.read(r, .en),
                                 tracks: tracks, handles: Resolver.handles(for: tracks, table: HandleTable()), options: RenderOptions())
    }

    private func skipUnlessFixture(_ name: String) throws {
        let relative = "ax/\(name).json"
        guard FileManager.default.fileExists(atPath: Fixtures.url(relative).path) else {
            throw XCTSkip("missing fixture file: Tests/Fixtures/\(relative)")
        }
    }

    func testTrackLine() {
        let t = TrackInfo(number: 4, name: "PreDelay", mute: true, selected: true, hasOutput: false, volume: "-4.2 dB")
        XCTAssertEqual(TextRenderer.trackLine(t, handle: "#t1a2b"), "track:4 #t1a2b \"PreDelay\" M vol=-4.2dB [selected] ⚠ no output")
    }

    func testFoldingKeepsPriorityRowsAndOffersPaging() {
        let tracks = (1...40).map { TrackInfo(number: $0, name: "T\($0)", selected: $0 == 33) }
        let text = TextRenderer.root(project: ProjectInfo(name: "big", logicVersion: nil), transport: nil, tracks: tracks,
                                     handles: tracks.map { "#t\($0.number)" }, options: RenderOptions())
        XCTAssertTrue(text.contains("tracks:40 (showing 12; page:\"13-24\" or fields:\"name,mute\")"))
        XCTAssertTrue(text.contains("track:33"))
        XCTAssertEqual(text.components(separatedBy: "\n").filter { $0.hasPrefix(" track:") }.count, 12)
        let page = TextRenderer.root(project: ProjectInfo(name: "big", logicVersion: nil), transport: nil, tracks: tracks,
                                     handles: tracks.map { "#t\($0.number)" }, options: RenderOptions(page: 13...24))
        XCTAssertTrue(page.contains(" track:13 ") && page.contains(" track:24 ") && !page.contains(" track:25 "))
        let f = TextRenderer.root(project: ProjectInfo(name: "big", logicVersion: nil), transport: nil, tracks: tracks,
                                  handles: tracks.map { "#t\($0.number)" }, options: RenderOptions(fields: ["name", "mute"]))
        XCTAssertTrue(f.contains(" track:40 \"T40\" mute=?"))
    }

    func testBudgets() throws {
        try skipUnlessFixture("belo-krasny")
        XCTAssertLessThanOrEqual(TokenEstimate.count(try fixtureRoot("belo-krasny")), 350)
        try skipUnlessFixture("big")
        XCTAssertLessThanOrEqual(TokenEstimate.count(try fixtureRoot("big")), 350)
        let r = FixtureAXRoot(try AXFixture.load(Fixtures.url("ax/belo-krasny.json")))
        let tracks = try TrackReader.read(r, .en)
        let sel = try XCTUnwrap(tracks.first(where: \.selected))
        let text = TextRenderer.track(sel, handle: "#t1a2b", strip: try StripReader.inspector(r, .en))
        XCTAssertLessThanOrEqual(TokenEstimate.count(text), 200)
    }
}
