import XCTest
@testable import LogicKit

final class SessionTests: XCTestCase {
    func session(_ fixture: String = "mini", ledger: Ledger = Ledger(entries: [])) throws -> LogicSession {
        let root = FixtureAXRoot(try AXFixture.load(Fixtures.url("ax/\(fixture).json")))
        return LogicSession(locale: .en, executor: AXExecutor(healthProbe: { true }), ledger: ledger,
                            rootFactory: { root }, pidProvider: { nil }, logicMinor: { nil })
    }

    func testReadRootTrackStrip() async throws {
        let s = try session()
        let root = try await s.read("/")
        XCTAssertTrue(root.contains("tracks:4"))
        XCTAssertTrue(root.contains("[selected]"))
        let t2 = try await s.read("track:2")
        XCTAssertTrue(t2.contains(" strip vol=-4.2dB"))
        XCTAssertTrue(t2.contains("insert:1 Channel EQ · 2 ChromaVerb(bypass)"))
        let t1 = try await s.read("track:1")
        XCTAssertTrue(t1.contains("?unavailable(need_select"))
        let viaStack = try await s.read("track:2/track:1")
        XCTAssertEqual(viaStack, t1)
        let raw = try await s.read("track:1/raw")
        XCTAssertTrue(raw.contains("AXCheckBox d=\"Mute\""))
    }

    func testReadErrorsAndSchema() async throws {
        let s = try session()
        do { _ = try await s.read("track:\"Nope\""); XCTFail() } catch let e as LogicError { XCTAssertEqual(e.code, "not_found") }
        let schema = try await s.read("system/schema/track")
        XCTAssertTrue(schema.contains("no live-verified"))   // empty ledger → nothing advertised
    }

    func testSetRequiresAdvertisedAndValidValue() async throws {
        do { _ = try await session().set([("track:1/mute", "on")]); XCTFail() }
        catch let e as LogicError { XCTAssertEqual(e.code, "unsupported") }
        var l = Ledger(entries: [])
        l.record(Grammar.find(.track, "mute")!, version: "11.2", date: "x")
        do { _ = try await session(ledger: l).set([("track:1/mute", "maybe")]); XCTFail() }
        catch let e as LogicError { XCTAssertEqual(e.code, "invalid_value") }
        // fixture is read-only: a real attempt fails as unsupported, proving the recipe ran through the runner
        do { _ = try await session(ledger: l).set([("track:1/mute", "on")]); XCTFail() }
        catch let e as LogicError { XCTAssertEqual(e, .unsupported("fixture is read-only")) }
    }
}
