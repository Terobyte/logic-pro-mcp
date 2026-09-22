import XCTest
import LogicKit

final class LiveTransportTests: LiveCase {
    func testPlayStop() throws {
        let root = try Live.require()
        XCTAssertEqual(try RecipeRunner.run(TransportCommand(command: .play), env: env(root)), .ok(path: "transport", actual: "playing"))
        XCTAssertEqual(try RecipeRunner.run(TransportCommand(command: .stop), env: env(root)), .ok(path: "transport", actual: "stopped"))
        try LiveLedger.pass(.transport, "play")
        try LiveLedger.pass(.transport, "stop")
    }

    func testLocate() throws {
        let root = try Live.require()
        let target = BarPosition(bar: 5)
        XCTAssertEqual(try RecipeRunner.run(Locate(position: target), env: env(root)), .ok(path: "transport/position", actual: "5 1 1 1"))
        _ = try RecipeRunner.run(Locate(position: BarPosition(bar: 1)), env: env(root))
        try LiveLedger.pass(.transport, "position")
    }
}
