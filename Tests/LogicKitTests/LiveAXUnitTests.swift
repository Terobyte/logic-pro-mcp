import XCTest
@testable import LogicKit

final class LiveAXUnitTests: XCTestCase {
    func testScalarConversionDistinguishesBoolFromNumber() {
        XCTAssertEqual(LiveAXNode.scalar(kCFBooleanTrue), .bool(true))
        XCTAssertEqual(LiveAXNode.scalar(NSNumber(value: 173)), .number(173))
        XCTAssertEqual(LiveAXNode.scalar("x" as NSString), .string("x"))
        XCTAssertNil(LiveAXNode.scalar(NSArray()))
    }

    func testMinorVersion() {
        XCTAssertEqual(LogicApp.minor("11.2.1"), "11.2")
        XCTAssertEqual(LogicApp.minor("11.2"), "11.2")
    }

    func testFixtureGuard() {
        XCTAssertTrue(FixtureGuard.allows(mainWindowTitle: "fixture-big - Tracks"))
        XCTAssertFalse(FixtureGuard.allows(mainWindowTitle: "бело красный - Tracks"))
        XCTAssertFalse(FixtureGuard.allows(mainWindowTitle: nil))
    }

    func testStatsCount() {
        let s = AXStats()
        s.message(); s.message(2); s.timeout()
        XCTAssertEqual(s.messages, 3)
        XCTAssertEqual(s.timeouts, 1)
        s.reset()
        XCTAssertEqual(s.messages, 0)
    }
}
