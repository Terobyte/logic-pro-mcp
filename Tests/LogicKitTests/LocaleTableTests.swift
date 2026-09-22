import XCTest
@testable import LogicKit

final class LocaleTableTests: XCTestCase {
    func testEveryAnchorHasAString() {
        for a in Anchor.allCases { XCTAssertFalse(LocaleTable.en[a].isEmpty, a.rawValue) }
    }
    func testListAnchor() {
        XCTAssertTrue(LocaleTable.en.list(.modalSubroles).contains("AXDialog"))
    }
}
