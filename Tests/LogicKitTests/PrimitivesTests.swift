import XCTest
@testable import LogicKit

final class ScriptedSlider: AXNode, @unchecked Sendable {
    var ladder: [Double], index: Int, inverted = false
    init(_ ladder: [Double], at index: Int) { self.ladder = ladder; self.index = index }
    func attrs() throws -> AXAttrs { AXAttrs(role: "AXSlider", valueDescription: "\(ValueParser.trim(ladder[index])) dB") }
    func children() throws -> [any AXNode] { [] }
    func perform(_ a: String) throws {
        var up = a == "AXIncrement"
        if inverted { up.toggle() }
        index = up ? min(index + 1, ladder.count - 1) : max(index - 1, 0)
    }
    func set(_ attribute: String, _ value: AXScalar) throws { throw AXCallError.notSupported("set") }
    var identityToken: Int { 1 }
}

final class FakeTime: @unchecked Sendable { var t = 0.0 }

final class PrimitivesTests: XCTestCase {
    let ft = FakeTime()
    lazy var clock = Clock(now: { [ft] in ft.t }, sleep: { [ft] in ft.t += $0 })
    let dB: (String) -> Double? = { ValueParser.parseDisplay($0, unit: .dB).flatMap(ValueParser.magnitude) }
    let fmt: (Double) -> String = { "\(ValueParser.trim($0)) dB" }
    let ladder = [-30.0, -25, -20, -15, -10]

    func testReachesExactTarget() throws {
        let s = ScriptedSlider(ladder, at: 2)
        let r = try Primitives.stepTo(s, target: -10, parse: dB, clock: clock)
        XCTAssertEqual(r.actual, -10); XCTAssertEqual(r.steps, 2)
        XCTAssertNil(try StepContract.judge(want: -10, wantText: "-10 dB", result: r, format: fmt))
    }

    func testQuantizesToNearestWithBackStep() throws {
        let s = ScriptedSlider(ladder, at: 4)
        let r = try Primitives.stepTo(s, target: -22, parse: dB, clock: clock)
        XCTAssertEqual(r.actual, -20)
        XCTAssertEqual(try StepContract.judge(want: -22, wantText: "-22 dB", result: r, format: fmt),
                       Quantization(want: "-22 dB", step: "5 dB"))
    }

    func testStuckAtLimitFarFromTargetFails() throws {
        let s = ScriptedSlider(ladder, at: 2)
        let r = try Primitives.stepTo(s, target: -40, parse: dB, clock: clock)
        XCTAssertEqual(r.actual, -30)
        XCTAssertThrowsError(try StepContract.judge(want: -40, wantText: "-40 dB", result: r, format: fmt)) {
            XCTAssertEqual($0 as? LogicError, .verifyFailed(want: "-40 dB", got: "-30 dB"))
        }
    }

    func testWrongDirectionFails() {
        let s = ScriptedSlider(ladder, at: 2); s.inverted = true
        XCTAssertThrowsError(try Primitives.stepTo(s, target: -10, parse: dB, clock: clock))
    }

    func testPollTimesOutWithLastValue() throws {
        let r = try Verify.poll(deadline: clock.now() + 0.1, clock: clock, read: { 1 }, done: { $0 == 2 })
        XCTAssertFalse(r.ok); XCTAssertEqual(r.value, 1)
    }
}
