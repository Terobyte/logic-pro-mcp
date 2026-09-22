import XCTest
import MCP
import LogicKit
@testable import LogicMCP

final class ToolBudgetTests: XCTestCase {
    func testAllToolDescriptionsFitBudget() throws {
        let tools = ToolDefs.all(advertised: Grammar.all.filter { $0.status == .recipe })
        let json = String(decoding: try JSONEncoder().encode(tools), as: UTF8.self)
        XCTAssertLessThanOrEqual(TokenEstimate.count(json), 1500)
    }
}
