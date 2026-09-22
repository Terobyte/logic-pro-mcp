import XCTest
import LogicKit

final class LiveUndoTests: LiveCase {
    /// Menu path for "new audio track" as recorded in S9 Step 2.
    let newTrackMenu = ["Track", "New Audio Track"]

    func testUndoRedoNewTrack() throws {
        let root = try Live.require()
        let n0 = try TrackReader.read(root, .en).count
        try Primitives.menu(try XCTUnwrap(root.menuBar()), newTrackMenu)
        let r = try Verify.poll(deadline: Clock.system.now() + 2, clock: .system, read: { try TrackReader.read(root, .en).count }, done: { $0 == n0 + 1 })
        XCTAssertTrue(r.ok)
        _ = try RecipeRunner.run(UndoRedo(mode: .undo, steps: 1), env: env(root))
        XCTAssertEqual(try TrackReader.read(root, .en).count, n0)
        _ = try RecipeRunner.run(UndoRedo(mode: .redo, steps: 1), env: env(root))
        XCTAssertEqual(try TrackReader.read(root, .en).count, n0 + 1)
        _ = try RecipeRunner.run(UndoRedo(mode: .undo, steps: 1), env: env(root))
        XCTAssertEqual(try TrackReader.read(root, .en).count, n0)
        try LiveLedger.pass(.root, "undo")
        try LiveLedger.pass(.root, "redo")
    }
}
