import XCTest
@testable import LogicKit

final class HandlesTests: XCTestCase {
    func fp(_ n: Int, _ name: String, _ prev: String?, _ next: String?) -> Fingerprint {
        Fingerprint(kind: .track, number: n, name: name, parent: "/", prev: prev, next: next)
    }

    func testHandleIsStableShortAndPrefixed() {
        let t = HandleTable()
        let h = t.handle(for: fp(3, "C", "B", "D"))
        XCTAssertEqual(h, t.handle(for: fp(3, "C", "B", "D")))
        XCTAssertTrue(h.hasPrefix("#t"))
        XCTAssertEqual(h.count, 6)
        XCTAssertEqual(t.fingerprint(h), fp(3, "C", "B", "D"))
        t.reset()
        XCTAssertNil(t.fingerprint(h))
    }

    func testMatchRules() {
        let c = fp(3, "C", "B", "D")
        XCTAssertEqual(HandleTable.match(c, in: [fp(1, "A", nil, "B"), fp(2, "B", "A", "C"), c]), .exact(2))
        // A track inserted at the top: C is now 4, neighbours unchanged → moved
        XCTAssertEqual(HandleTable.match(c, in: [fp(1, "X", nil, "A"), fp(2, "A", "X", "B"), fp(3, "B", "A", "C"), fp(4, "C", "B", "D")]), .moved(3))
        // C deleted: B and D are now neighbours
        XCTAssertEqual(HandleTable.match(c, in: [fp(2, "B", "A", "D"), fp(3, "D", "B", nil)]), .stale)
        // same name only → stale, never a hijack
        XCTAssertEqual(HandleTable.match(c, in: [fp(9, "C", "Q", "R")]), .stale)
    }
}
