import XCTest
@testable import LogicKit

/// Red tests from bughunt 2026-09-21. Each must fail on unfixed code, then green after fix.
final class BughuntTests: XCTestCase {
    func test_B01_AXStatsMessageMustNotDecrease() {
        let s = AXStats()
        s.message(3)
        s.message(-2)
        XCTAssertEqual(s.messages, 3, "AX IPC budget counter must ignore or reject negative increments")
    }
}
