import XCTest
import LogicKit

/// Gate for every live test: LOGIC_LIVE=1, Accessibility, Logic running, a fixture- project in front.
enum Live {
    static func require() throws -> LiveAXRoot {
        guard ProcessInfo.processInfo.environment["LOGIC_LIVE"] == "1" else { throw XCTSkip("LOGIC_LIVE != 1") }
        guard LogicApp.axTrusted else { throw XCTSkip("Accessibility not granted to the test runner") }
        guard let pid = LogicApp.pid else { throw XCTSkip("Logic Pro is not running") }
        let root = LiveAXRoot(pid: pid)
        let title = try root.mainWindow()?.attrs().title
        guard FixtureGuard.allows(mainWindowTitle: title) else {
            XCTFail("open a fixture- project copy first (Scripts/fixture-open.sh); main window is \(title ?? "nil")")
            throw XCTSkip("not a fixture project")
        }
        return root
    }
}
