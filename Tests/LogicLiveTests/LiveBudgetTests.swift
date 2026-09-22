import XCTest
import LogicKit

final class LiveBudgetTests: LiveCase {
    /// Needs fixture-big in front (Scripts/fixture-open.sh big).
    func testReadRootOnBigWithinTimeAndAXBudget() async throws {
        let root = try Live.require()
        guard try root.mainWindow()?.attrs().title?.hasPrefix("fixture-big") == true else { throw XCTSkip("open fixture-big") }
        let session = LogicSession.live()
        _ = try await session.read("/")
        AXStats.shared.reset()
        let t0 = Date()
        let text = try await session.read("/")
        let ms = Date().timeIntervalSince(t0) * 1000
        XCTAssertLessThanOrEqual(ms, 400)
        XCTAssertLessThanOrEqual(AXStats.shared.messages, 300)
        XCTAssertLessThanOrEqual(TokenEstimate.count(text), 350)
    }
}
