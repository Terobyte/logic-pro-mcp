import XCTest
@testable import LogicKit

final class ErrorsTests: XCTestCase {
    func testTokenEstimateIsConservativeForCyrillic() {
        XCTAssertEqual(TokenEstimate.count("abcd"), 1)
        XCTAssertEqual(TokenEstimate.count("abcde"), 2)
        XCTAssertEqual(TokenEstimate.count("бело"), 4)
    }

    func testCodes() {
        XCTAssertEqual(LogicError.staleRef("#t1").code, "stale_ref")
        XCTAssertEqual(LogicError.blocked(.recording).code, "blocked")
        XCTAssertEqual(LogicError.needMMCInput.code, "need_mmc_input")
    }

    func testErrorTextShapes() {
        XCTAssertEqual(LogicError.blocked(.modal("Save Patch as…")).text,
                       "blocked: modal \"Save Patch as…\" is open — close it in Logic or wait")
        XCTAssertEqual(LogicError.verifyFailed(want: "on", got: "off").text, "verify_failed: want on, got off")
        let amb = LogicError.ambiguous("track:\"Vox\"", candidates: ["track:2 \"Vox\"", "track:7 \"Vox\""]).text
        XCTAssertEqual(amb, "ambiguous: track:\"Vox\" matches 2\ncandidates: track:2 \"Vox\" · track:7 \"Vox\"")
    }

    func testErrorBudgets() {
        let many = (1...40).map { "track:\($0) \"Очень длинное имя трека номер \($0) с хвостом\"" }
        let t = LogicError.notFound("track:\"Вокал\"", candidates: many).text
        XCTAssertLessThanOrEqual(TokenEstimate.count(t), 150)
        XCTAssertLessThanOrEqual(TokenEstimate.count(t.components(separatedBy: "\n")[0]), 60)
        XCTAssertLessThanOrEqual(t.components(separatedBy: " · ").count, 5)
        let long = LogicError.unavailable(String(repeating: "очень долго ", count: 40)).text
        XCTAssertLessThanOrEqual(TokenEstimate.count(long), 60)
    }

    func testOutcomeText() {
        let q = Outcome.ok(path: "track:3/insert:2/param:Threshold", actual: "-20 dB",
                           quantized: Quantization(want: "-22 dB", step: "5 dB"))
        XCTAssertEqual(q.text, "✓ track:3/insert:2/param:Threshold = -20 dB (want -22 dB, step 5 dB)")
        XCTAssertEqual(Outcome.ok(path: "track:1/mute", actual: "on").appending(notes: ["⚠ project unsaved"]).text,
                       "✓ track:1/mute = on\n⚠ project unsaved")
        XCTAssertEqual(Outcome.sent("3 events").text, "→ sent 3 events")
    }
}
