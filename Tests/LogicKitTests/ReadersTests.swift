import XCTest
@testable import LogicKit

final class ReadersTests: XCTestCase {
    let L = LocaleTable.en
    func root(_ name: String) throws -> FixtureAXRoot { FixtureAXRoot(try AXFixture.load(Fixtures.url("ax/\(name).json"))) }

    private func rootOrSkip(_ name: String) throws -> FixtureAXRoot {
        let relative = "ax/\(name).json"
        let url = Fixtures.url(relative)
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw XCTSkip("missing fixture file: Tests/Fixtures/\(relative)")
        }
        return FixtureAXRoot(try AXFixture.load(url))
    }

    func testRowDesc() {
        XCTAssertEqual(TrackRowDesc.parse("Track 4 “PreDelay”, no output", locale: L),
                       TrackRowDesc(number: 4, name: "PreDelay", flags: ["no output"]))
        XCTAssertEqual(TrackRowDesc.parse("Track 3 “Warm, Vocal”, Take", locale: L)?.name, "Warm, Vocal")
        XCTAssertNil(TrackRowDesc.parse("Region 1", locale: L))
    }

    func testMiniTracks() throws {
        let tracks = try TrackReader.read(try root("mini"), L)
        XCTAssertEqual(tracks.map(\.number), [1, 2, 3, 4])
        XCTAssertEqual(tracks[0].solo, true)
        XCTAssertEqual(tracks[0].mute, false)
        XCTAssertEqual(tracks[0].volume, "0.0 dB")
        XCTAssertEqual(tracks[1].kind, .stack)
        XCTAssertEqual(tracks[2].takeLanes, 2)
        XCTAssertFalse(tracks[3].hasOutput)
        XCTAssertEqual(try TrackReader.selectedNumber(try root("mini"), L), 2)
        XCTAssertEqual(try TrackReader.row(number: 3, try root("mini"), L).attrs().desc, "Track 3 “Warm Vocal”")
    }

    func testMiniStripTransportModal() throws {
        let r = try root("mini")
        let strip = try XCTUnwrap(StripReader.inspector(r, L))
        XCTAssertEqual(strip.volume, "-4.2 dB")
        XCTAssertEqual(strip.inserts, [InsertInfo(slot: 1, name: "Channel EQ", bypassed: false),
                                       InsertInfo(slot: 2, name: "ChromaVerb", bypassed: true)])
        XCTAssertEqual(strip.peak, "-4.7 dB")
        XCTAssertEqual(try TransportReader.read(r, L).state, .stopped)
        XCTAssertNil(try ModalGuard.modalTitle(r, L))
        XCTAssertEqual(try ProjectReader.read(r, version: "11.2").name, "fixture-mini")
        XCTAssertEqual(try AnchorProbe.missing(r, L), [])
    }

    func testBeloKrasnyMatchesGroundTruth() throws {
        let r = try rootOrSkip("belo-krasny")
        let tracks = try TrackReader.read(r, L)
        XCTAssertEqual(tracks.count, 5)
        let names = Set(tracks.map(\.name))
        for n in ["Rose Vocal", "PreDelay", "Warmth"] { XCTAssertTrue(names.contains(n), n) }
        XCTAssertEqual(tracks.first { $0.name == "PreDelay" }?.hasOutput, false)
        XCTAssertGreaterThanOrEqual(tracks.map(\.takeLanes).max() ?? 0, 15)
        XCTAssertEqual(tracks.filter(\.selected).map(\.name), ["Rose Vocal"])
        let strip = try XCTUnwrap(StripReader.inspector(r, L))
        XCTAssertEqual(strip.inserts.count, 5)
        XCTAssertTrue(strip.inserts[0].name.hasPrefix("Channel"))
    }

    func testBigHasAllTracks() throws {
        // S12 🟢: AX exposes every track row. If S12 was not green, replace with the spec §4.6 rule recorded in Task 16.
        let r = try rootOrSkip("big")
        XCTAssertGreaterThanOrEqual(try TrackReader.read(r, L).count, 40)
    }
}
