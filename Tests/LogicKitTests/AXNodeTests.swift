import XCTest
@testable import LogicKit

final class AXNodeTests: XCTestCase {
    func mini() throws -> FixtureAXRoot {
        FixtureAXRoot(try AXFixture.load(Fixtures.url("ax/mini.json")))
    }

    func testScalarDecodesBoolNumberString() throws {
        let data = #"[true, 3, 2.5, "x"]"#.data(using: .utf8)!
        let v = try JSONDecoder().decode([AXScalar].self, from: data)
        XCTAssertEqual(v, [.bool(true), .number(3), .number(2.5), .string("x")])
        XCTAssertEqual(AXScalar.number(3).stringValue, "3")
        XCTAssertEqual(AXScalar.number(2.5).stringValue, "2.5")
    }

    func testFixtureLoadsRootsAndAttrs() throws {
        let root = try mini()
        let main = try XCTUnwrap(root.mainWindow())
        XCTAssertEqual(try main.attrs().title, "fixture-mini - Tracks")
        XCTAssertEqual(try main.children().count, 3)
        XCTAssertNil(try root.focusedWindow())
    }

    func testFixtureIsReadOnly() throws {
        let main = try XCTUnwrap(try mini().mainWindow())
        XCTAssertThrowsError(try main.perform("AXPress")) { XCTAssertEqual($0 as? AXCallError, .readOnlyFixture) }
    }

    func testFixtureChildIdentityIsStable() throws {
        let main = try XCTUnwrap(try mini().mainWindow())
        XCTAssertEqual(try main.children()[0].identityToken, try main.children()[0].identityToken)
    }

    func testFirstDescendantIsBreadthFirst() throws {
        let main = try XCTUnwrap(try mini().mainWindow())
        let mute = try XCTUnwrap(main.firstDescendant(AXMatch(role: "AXCheckBox", desc: .equals("Mute"))))
        // BFS: the first Mute belongs to Track 1
        XCTAssertEqual(try mute.attrs().value, .number(0))
        let row = try XCTUnwrap(main.firstDescendant(AXMatch(desc: .prefix("Track 4"))))
        XCTAssertEqual(try row.attrs().desc, "Track 4 “PreDelay”, no output")
    }

    func testAllDescendantsStopsAtMatchesByDefault() throws {
        let main = try XCTUnwrap(try mini().mainWindow())
        let groups = try main.allDescendants(AXMatch(role: "AXGroup"))
        XCTAssertEqual(groups.count, 3) // Tracks header, Control Bar, plugin container
        let deep = try main.allDescendants(AXMatch(role: "AXGroup"), descendIntoMatches: true)
        XCTAssertEqual(deep.count, 5)
    }

    func testMatchOps() {
        let a = AXAttrs(role: "AXButton", title: "Undo Insert", desc: "open")
        XCTAssertTrue(AXMatch(role: "AXButton", title: .prefix("Undo")).matches(a))
        XCTAssertTrue(AXMatch(title: .contains("Insert")).matches(a))
        XCTAssertFalse(AXMatch(desc: .equals("list")).matches(a))
        XCTAssertFalse(AXMatch(help: .prefix("x")).matches(a)) // nil never matches an op
    }

    func testCaptureRoundTripsFixture() throws {
        let fx = try AXFixture.load(Fixtures.url("ax/mini.json"))
        let main = FixtureAXNode(try XCTUnwrap(fx.roots["mainWindow"]))
        var stats = CaptureStats()
        let snap = try AXCapture.capture(main, depth: 50, stats: &stats)
        XCTAssertEqual(snap, fx.roots["mainWindow"])
        XCTAssertEqual(stats.nodes, 25)
        var shallow = CaptureStats()
        let cut = try AXCapture.capture(main, depth: 1, stats: &shallow)
        XCTAssertEqual(cut.c.count, 3)
        XCTAssertEqual(cut.c[0].truncated, true)
    }

    func testCompactLine() {
        let a = AXAttrs(role: "AXSlider", desc: "volume fader", value: .number(173), valueDescription: "-4.2 dB",
                        actions: ["AXIncrement", "AXDecrement", "AXShowMenu"])
        XCTAssertEqual(a.compactLine, #"AXSlider d="volume fader" v="173" vd="-4.2 dB" {Increment,Decrement}"#)
    }
}
