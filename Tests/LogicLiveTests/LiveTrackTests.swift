import XCTest
import LogicKit

final class LiveTrackTests: LiveCase {
    func roundTrip(_ which: TrackToggle.Which) throws {
        let root = try Live.require()
        let t = try XCTUnwrap(TrackReader.read(root, .en).first)
        let original = (which == .mute ? t.mute : t.solo) ?? false
        let path = "track:\(t.number)/\(which.rawValue)"
        XCTAssertEqual(try RecipeRunner.run(TrackToggle(track: t.number, which: which, on: !original), env: env(root)),
                       .ok(path: path, actual: !original ? "on" : "off"))   // no notes = no window side effects
        let now = try XCTUnwrap(TrackReader.read(root, .en).first)
        XCTAssertEqual(which == .mute ? now.mute : now.solo, !original)
        _ = try RecipeRunner.run(TrackToggle(track: t.number, which: which, on: original), env: env(root))
        XCTAssertEqual(try RecipeRunner.run(TrackToggle(track: t.number, which: which, on: original), env: env(root)),
                       .ok(path: path, actual: original ? "on" : "off"))   // idempotent no-op
    }

    func testMuteRoundTrip() throws { try roundTrip(.mute); try LiveLedger.pass(.track, "mute") }
    func testSoloRoundTrip() throws { try roundTrip(.solo); try LiveLedger.pass(.track, "solo") }

    func testSelectAndRestore() throws {
        let root = try Live.require()
        let tracks = try TrackReader.read(root, .en)
        let original = try XCTUnwrap(tracks.first(where: \.selected))
        let other = try XCTUnwrap(tracks.first { !$0.selected })
        XCTAssertEqual(try RecipeRunner.run(SelectTrack(track: other.number), env: env(root)), .ok(path: "track:\(other.number)", actual: "selected"))
        XCTAssertEqual(try TrackReader.selectedNumber(root, .en), other.number)
        _ = try RecipeRunner.run(SelectTrack(track: original.number), env: env(root))
        let after = try TrackReader.read(root, .en)
        XCTAssertEqual(after.first(where: \.selected)?.number, original.number)
        XCTAssertEqual(after.first { $0.number == other.number }?.arm, other.arm)   // arm unchanged (S8)
        try LiveLedger.pass(.track, "select")
    }

    /// §12.2: the invariant holds on the error path too.
    func testAbortLeavesNoWindowSideEffects() throws {
        let root = try Live.require()
        let before = try WindowSnapshot.capture(logicPID: root.pid, root: root)
        struct Boom: Recipe {
            var spec: RecipeSpec { RecipeSpec(name: "boom") }
            func run(_ ctx: RecipeContext) throws -> Outcome { throw LogicError.unavailable("forced abort") }
        }
        XCTAssertThrowsError(try RecipeRunner.run(Boom(), env: env(root)))
        XCTAssertTrue(before.diff(to: try WindowSnapshot.capture(logicPID: root.pid, root: root)).isClean)
    }
}
