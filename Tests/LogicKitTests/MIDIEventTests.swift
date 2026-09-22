import XCTest
@testable import LogicKit

final class MIDIEventTests: XCTestCase {
    func testBytesAndValidation() throws {
        XCTAssertEqual(MIDIEvent.note(ch: 1, note: 60, vel: 100, durMs: 250).onBytes, [0x90, 60, 100])
        XCTAssertEqual(MIDIEvent.note(ch: 2, note: 60, vel: 100, durMs: 250).offBytes, [0x81, 60, 0])
        XCTAssertEqual(MIDIEvent.cc(ch: 16, cc: 7, value: 127).onBytes, [0xBF, 7, 127])
        XCTAssertEqual(MIDIEvent.pitchBend(ch: 1, value: 8192).onBytes, [0xE0, 0x00, 0x40])
        XCTAssertThrowsError(try MIDIEvent.note(ch: 17, note: 60, vel: 1, durMs: 1).validate())
        XCTAssertThrowsError(try MIDIEvent.cc(ch: 1, cc: 128, value: 0).validate())
    }
}
