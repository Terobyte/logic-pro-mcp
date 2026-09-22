import XCTest
@testable import LogicKit

final class ResolverTests: XCTestCase {
    let tracks = [TrackInfo(number: 1, name: "Beat"), TrackInfo(number: 2, name: "Vox", selected: true),
                  TrackInfo(number: 3, name: "Vox"), TrackInfo(number: 4, name: "PreDelay")]

    func testNumberNameSelected() throws {
        let t = HandleTable()
        XCTAssertEqual(try Resolver.track(.number(4), in: tracks, table: t).0.name, "PreDelay")
        XCTAssertEqual(try Resolver.track(.name("Beat"), in: tracks, table: t).0.number, 1)
        XCTAssertEqual(try Resolver.track(.selected, in: tracks, table: t).0.number, 2)
        XCTAssertThrowsError(try Resolver.track(.name("Vox"), in: tracks, table: t)) {
            XCTAssertEqual($0 as? LogicError, .ambiguous("track:\"Vox\"", candidates: ["track:2 \"Vox\"", "track:3 \"Vox\""]))
        }
        XCTAssertThrowsError(try Resolver.track(.name("pre"), in: tracks, table: t)) {
            XCTAssertEqual($0 as? LogicError, .notFound("track:\"pre\"", candidates: ["track:4 \"PreDelay\""]))
        }
        XCTAssertThrowsError(try Resolver.track(.number(9), in: tracks, table: t))
    }

    func testHandlesExactMovedStale() throws {
        let t = HandleTable()
        let h = Resolver.handles(for: tracks, table: t)[3]   // PreDelay: prev Vox, next nil
        XCTAssertEqual(try Resolver.track(.handle(h), in: tracks, table: t).1, nil)
        let shifted = [TrackInfo(number: 1, name: "New")] + tracks.map { var x = $0; x.number += 1; return x }
        let (moved, note) = try Resolver.track(.handle(h), in: shifted, table: t)
        XCTAssertEqual(moved.number, 5)
        XCTAssertEqual(note, "moved 4→5")
        XCTAssertThrowsError(try Resolver.track(.handle(h), in: Array(tracks.dropLast()), table: t)) {
            XCTAssertEqual($0 as? LogicError, .staleRef(h))
        }
        XCTAssertThrowsError(try Resolver.track(.handle("#t0000"), in: tracks, table: t))
    }

    func testCanonicalStackPath() throws {
        XCTAssertEqual(Resolver.canonical(try LPath.parse("track:3/track:5/strip")).description, "track:5/strip")
    }
}
