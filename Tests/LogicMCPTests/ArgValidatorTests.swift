import XCTest
import MCP
import LogicKit
@testable import LogicMCP

final class ArgValidatorTests: XCTestCase {
    func testReadDefaultsAndChecks() throws {
        let a = try ArgValidator.read(nil)
        XCTAssertEqual(a.path, "/"); XCTAssertEqual(a.depth, 1)
        XCTAssertEqual(try ArgValidator.read(["path": .string("track:3"), "fields": .string("name,mute")]).fields, ["name", "mute"])
        XCTAssertThrowsError(try ArgValidator.read(["depth": .int(9)]))
        XCTAssertThrowsError(try ArgValidator.read(["bogus": .string("x")]))
    }

    func testSetAndDo() throws {
        let s = try ArgValidator.set(["assign": .array([.object(["path": .string("track:1/mute"), "value": .string("on")])])])
        XCTAssertEqual(s.first?.path, "track:1/mute")
        XCTAssertThrowsError(try ArgValidator.set(["assign": .array([])]))
        let d = try ArgValidator.perform(["path": .string("/"), "action": .string("undo"), "args": .object(["steps": .int(2)])])
        XCTAssertEqual(d.first?.args["steps"], "2")
        let multi = try ArgValidator.perform(["steps": .array([.object(["path": .string("transport"), "action": .string("play")])])])
        XCTAssertEqual(multi.count, 1)
        XCTAssertThrowsError(try ArgValidator.perform(["path": .string("/")]))
    }
}
