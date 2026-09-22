import XCTest
@testable import LogicKit

final class AXLocatorTests: XCTestCase {
    func root() throws -> FixtureAXRoot { FixtureAXRoot(try AXFixture.load(Fixtures.url("ax/mini.json"))) }

    func testParseStepsOpsAndIndex() throws {
        let loc = try AXLocator.parse("role=AXGroup;desc=Tracks header > desc^=Track 3 “Warm Vocal”, Take[1]")
        XCTAssertEqual(loc.steps.count, 2)
        XCTAssertEqual(loc.steps[0].match, AXMatch(role: "AXGroup", desc: .equals("Tracks header")))
        XCTAssertEqual(loc.steps[1].match, AXMatch(desc: .prefix("Track 3 “Warm Vocal”, Take")))
        XCTAssertEqual(loc.steps[1].index, 1)
        XCTAssertEqual(try AXLocator.parse("title~=Undo").steps[0].match, AXMatch(title: .contains("Undo")))
    }

    func testParseRejectsBadFields() {
        XCTAssertThrowsError(try AXLocator.parse("colour=red"))
        XCTAssertThrowsError(try AXLocator.parse("role"))
        XCTAssertThrowsError(try AXLocator.parse("role^=AX"))   // role/subrole/id accept only '='
    }

    func testResolve() throws {
        let main = try XCTUnwrap(try root().mainWindow())
        let row = try XCTUnwrap(AXLocator.parse("desc=Tracks header > desc^=Track 2").resolve(from: main))
        XCTAssertEqual(try row.attrs().desc, "Track 2 “Rose Vocal”")
        let mutes = try AXLocator.parse("desc=Tracks header > desc=Mute").resolveAll(from: main)
        XCTAssertEqual(mutes.count, 2)
        XCTAssertNil(try AXLocator.parse("desc=Nope").resolve(from: main))
        XCTAssertNil(try AXLocator.parse("desc=Mute[5]").resolve(from: main))
    }

    func testMenuPath() throws {
        let bar = try XCTUnwrap(try root().menuBar())
        XCTAssertEqual(MenuPath.split("Edit > ^Undo"), ["Edit", "^Undo"])
        let undo = try XCTUnwrap(MenuPath.resolve(menuBar: bar, path: ["Edit", "^Undo"]))
        XCTAssertEqual(try undo.attrs().title, "Undo Insert Plug-in")
        let redo = try XCTUnwrap(MenuPath.resolve(menuBar: bar, path: ["Edit", "Redo"]))
        XCTAssertEqual(try redo.attrs().enabled, false)
        XCTAssertNil(try MenuPath.resolve(menuBar: bar, path: ["File", "Open"]))
    }
}
