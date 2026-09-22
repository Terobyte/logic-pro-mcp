import XCTest
import LogicKit

final class LiveSmokeTests: XCTestCase {
    func testMainWindowIsReadable() throws {
        let root = try Live.require()
        AXStats.shared.reset()
        let a = try XCTUnwrap(root.mainWindow()).attrs()
        XCTAssertEqual(a.role, "AXWindow")
        XCTAssertGreaterThan(AXStats.shared.messages, 0)
    }
}
