import XCTest
import CoreGraphics
@testable import LogicKit

final class WindowSnapshotTests: XCTestCase {
    func win(_ n: Int, pid: Int32, name: String? = nil, layer: Int = 0, on: Bool = true) -> [String: Any] {
        var d: [String: Any] = [kCGWindowNumber as String: n, kCGWindowOwnerPID as String: pid,
                                kCGWindowLayer as String: layer, kCGWindowIsOnscreen as String: on]
        if let name { d[kCGWindowName as String] = name }
        return d
    }

    func testRecordsParseAndSkipMalformed() {
        let recs = WindowSnapshot.records(from: [win(10, pid: 5, name: "Tracks"), [kCGWindowNumber as String: 3]])
        XCTAssertEqual(recs, [CGWindowRecord(number: 10, name: "Tracks", layer: 0, onScreen: true, ownerPID: 5)])
    }

    func testAssembleSplitsLogicAndUserSides() {
        let all = WindowSnapshot.records(from: [win(10, pid: 5), win(11, pid: 5, on: false), win(12, pid: 5, layer: 25), win(20, pid: 9)])
        let on = WindowSnapshot.records(from: [win(10, pid: 5), win(20, pid: 9), win(21, pid: 9, layer: 25)])
        let s = WindowSnapshot.assemble(all: all, onScreen: on, logicPID: 5,
                                        main: AXAttrs(subrole: "AXStandardWindow", title: "fixture-x - Tracks"),
                                        focused: nil, frontmostBundleID: "com.apple.Terminal")
        XCTAssertEqual(s.logicWindows.map(\.number), [10, 11])   // layer-0 only, any Space
        XCTAssertEqual(s.userOnScreenWindowNumbers, [20])        // layer-0, not Logic
        XCTAssertEqual(s.mainWindowTitle, "fixture-x - Tracks")
    }

    func testDiffDetectsNewWindowAndFocusSteal() {
        let before = WindowSnapshot(logicWindows: [CGWindowRecord(number: 10, name: nil, layer: 0, onScreen: false, ownerPID: 5)],
                                    mainWindowTitle: "p", mainWindowSubrole: "AXStandardWindow", focusedWindowTitle: "p",
                                    userFrontmostBundleID: "com.apple.Terminal", userOnScreenWindowNumbers: [20, 21])
        var after = before
        XCTAssertTrue(before.diff(to: after).isClean)
        after.logicWindows.append(CGWindowRecord(number: 44, name: "Search", layer: 0, onScreen: true, ownerPID: 5))
        after.userFrontmostBundleID = LogicApp.bundleID
        after.userOnScreenWindowNumbers = [44]
        let d = before.diff(to: after)
        XCTAssertEqual(d.newLogicWindows.map(\.number), [44])
        XCTAssertTrue(d.userFrontmostChanged)
        XCTAssertTrue(d.userSpaceChanged)
        XCTAssertFalse(d.isClean)
        XCTAssertTrue(d.summary.contains("new logic window 44"))
    }
}
