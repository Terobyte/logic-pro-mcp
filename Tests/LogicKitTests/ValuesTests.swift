import XCTest
@testable import LogicKit

final class ValuesTests: XCTestCase {
    func p(_ s: String, _ u: ValueUnit) throws -> LogicValue { try ValueParser.parse(s, unit: u) }

    func testDecibels() throws {
        XCTAssertEqual(try p("-6 dB", .dB), .dB(-6))
        XCTAssertEqual(try p("-4.2dB", .dB), .dB(-4.2))
        XCTAssertEqual(try p("-inf", .dB), .dB(-.infinity))
        XCTAssertEqual(try p("3", .dB), .dB(3))
        XCTAssertThrowsError(try p("loud", .dB))
        XCTAssertEqual(ValueParser.format(.dB(-.infinity)), "-inf dB")
        XCTAssertEqual(ValueParser.format(.dB(-4.2)), "-4.2 dB")
    }

    func testPan() throws {
        XCTAssertEqual(try p("L12", .pan), .pan(-12))
        XCTAssertEqual(try p("R5", .pan), .pan(5))
        XCTAssertEqual(try p("C", .pan), .pan(0))
        XCTAssertEqual(try p("+7", .pan), .pan(7))
        XCTAssertThrowsError(try p("L99", .pan))
        XCTAssertEqual(ValueParser.format(.pan(-12)), "L12")
        XCTAssertEqual(ValueParser.parseDisplay("-3.0", unit: .pan), .pan(-3))
    }

    func testTimesPercentToggles() throws {
        XCTAssertEqual(try p("38 ms", .ms), .ms(38))
        XCTAssertEqual(try p("1.6 s", .ms), .ms(1600))
        XCTAssertEqual(try p("1.6 s", .seconds), .seconds(1.6))
        XCTAssertEqual(try p("20%", .percent), .percent(20))
        XCTAssertEqual(try p("on", .onOff), .bool(true))
        XCTAssertEqual(try p("0", .onOff), .bool(false))
        XCTAssertThrowsError(try p("maybe", .onOff))
        XCTAssertEqual(ValueParser.format(.ms(38)), "38 ms")
    }

    func testPositions() throws {
        XCTAssertEqual(try p("17 1 1 1", .position), .position(BarPosition(bar: 17, beat: 1, division: 1, tick: 1)))
        XCTAssertEqual(try p("17", .position), .position(BarPosition(bar: 17, beat: 1, division: 1, tick: 1)))
        XCTAssertEqual(try p("17.3.1.1", .position), .position(BarPosition(bar: 17, beat: 3, division: 1, tick: 1)))
        XCTAssertThrowsError(try p("x 1", .position))
        XCTAssertLessThan(BarPosition.parse("9 4 4 240")!, BarPosition.parse("10")!)
    }

    func testDisplayAndMagnitude() {
        XCTAssertEqual(ValueParser.parseDisplay("-20.0 dB", unit: .dB).flatMap(ValueParser.magnitude), -20)
        XCTAssertNil(ValueParser.parseDisplay("garbage", unit: .dB))
    }
}
