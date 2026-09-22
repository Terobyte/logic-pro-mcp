import XCTest
import LogicKit

final class LiveGuardTests: LiveCase {
    func testMutationBlockedWhileRecording() throws {
        let root = try Live.require()
        let bar = try TransportReader.controlBar(root, .en)
        let record = try XCTUnwrap(bar.firstDescendant(AXMatch(desc: .equals(LocaleTable.en[.record])), maxDepth: 5))
        try Primitives.press(record)
        defer { _ = try? RecipeRunner.run(TransportCommand(command: .stop), env: env(root)) }
        _ = try Verify.poll(deadline: Clock.system.now() + 2, clock: .system,
                            read: { try TransportReader.read(root, .en).state }, done: { $0 == .recording })
        XCTAssertThrowsError(try RecipeRunner.run(TrackToggle(track: 1, which: .mute, on: true), env: env(root))) {
            XCTAssertEqual($0 as? LogicError, .blocked(.recording))
        }
        XCTAssertNoThrow(try RecipeRunner.run(TransportCommand(command: .stop), env: env(root)))
    }
}
