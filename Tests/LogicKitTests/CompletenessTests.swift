import XCTest
@testable import LogicKit

final class CompletenessTests: XCTestCase {
    /// Spec §5.6: every recipe capability has a recipe AND an existing live test.
    func testEveryRecipeCapabilityHasRecipeAndLiveTest() throws {
        let dir = Fixtures.root.deletingLastPathComponent().appendingPathComponent("LogicLiveTests")
        let sources = try FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "swift" }.map { try String(contentsOf: $0, encoding: .utf8) }.joined()
        for c in Grammar.all where c.status == .recipe {
            let test = try XCTUnwrap(c.liveTest, c.key)
            let parts = test.split(separator: "/")
            XCTAssertTrue(sources.contains("class \(parts[0])"), test)
            XCTAssertTrue(sources.contains("func \(parts[1])("), test)
            XCTAssertTrue(RecipeRegistry.has(c), c.key)
        }
    }
}
