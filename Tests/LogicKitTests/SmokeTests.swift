import XCTest
import LogicKit

final class SmokeTests: XCTestCase {
    func testLibraryVersionIsSet() {
        XCTAssertFalse(LogicKitInfo.version.isEmpty)
    }

    func testFixturesDirectoryIsFound() {
        XCTAssertTrue(FileManager.default.fileExists(atPath: Fixtures.url("README.md").path))
    }
}
