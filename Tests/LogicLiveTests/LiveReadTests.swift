import XCTest
import LogicKit

final class LiveReadTests: LiveCase {
    func session() throws -> LogicSession { _ = try Live.require(); return LogicSession.live() }

    func testReadRoot() async throws {
        let text = try await session().read("/")
        XCTAssertTrue(text.contains("tracks:"))
        XCTAssertLessThanOrEqual(TokenEstimate.count(text), 350)
        try LiveLedger.pass(.root, "read")
    }

    func testReadTrack() async throws {
        let text = try await session().read("track:1")
        XCTAssertTrue(text.hasPrefix("track:1 #t"))
        try LiveLedger.pass(.track, "read")
    }

    func testReadSelectedStrip() async throws {
        let text = try await session().read("track:selected/strip")
        XCTAssertTrue(text.contains("insert"))
        try LiveLedger.pass(.strip, "read")
    }

    func testReadTransport() async throws {
        let text = try await session().read("transport")
        XCTAssertTrue(text.hasPrefix("transport stopped") || text.hasPrefix("transport playing"))
        try LiveLedger.pass(.transport, "read")
    }
}
