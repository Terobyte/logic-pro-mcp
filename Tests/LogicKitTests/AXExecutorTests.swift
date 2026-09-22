import XCTest
import os
@testable import LogicKit

final class AXExecutorTests: XCTestCase {
    func expectBusy(_ op: () async throws -> Void, file: StaticString = #filePath, line: UInt = #line) async {
        do { try await op(); XCTFail("expected busy", file: file, line: line) }
        catch ExecutorError.busy {}
        catch { XCTFail("unexpected \(error)", file: file, line: line) }
    }

    func testJobsRunOneAtATimeOnTheAXThread() async throws {
        let ex = AXExecutor(healthProbe: { true })
        let log = OSAllocatedUnfairLock(initialState: [(name: String, start: Double, end: Double)]())
        try await withThrowingTaskGroup(of: Void.self) { group in
            for _ in 0..<8 {
                group.addTask {
                    try await ex.transaction {
                        let s = ProcessInfo.processInfo.systemUptime
                        Thread.sleep(forTimeInterval: 0.01)
                        let e = ProcessInfo.processInfo.systemUptime
                        log.withLock { $0.append((Thread.current.name ?? "", s, e)) }
                    }
                }
            }
            try await group.waitForAll()
        }
        let entries = log.withLock { $0 }.sorted { $0.start < $1.start }
        XCTAssertEqual(entries.count, 8)
        XCTAssertTrue(entries.allSatisfy { $0.name == AXExecutor.threadName })
        for (a, b) in zip(entries, entries.dropFirst()) { XCTAssertLessThanOrEqual(a.end, b.start) }
    }

    func testReturnsValuesAndRethrowsOtherErrors() async throws {
        let ex = AXExecutor(healthProbe: { true })
        let v = try await ex.read { 42 }
        XCTAssertEqual(v, 42)
        do { _ = try await ex.read { () -> Int in throw AXCallError.invalidElement }; XCTFail() }
        catch { XCTAssertEqual(error as? AXCallError, .invalidElement) }
        XCTAssertFalse(ex.isBusy)
    }

    func testTimeoutTurnsBusyUntilProbePasses() async throws {
        let clock = OSAllocatedUnfairLock(initialState: 0.0)
        let healthy = OSAllocatedUnfairLock(initialState: false)
        let ran = OSAllocatedUnfairLock(initialState: 0)
        let ex = AXExecutor(now: { clock.withLock { $0 } }, healthProbe: { healthy.withLock { $0 } })

        await expectBusy { _ = try await ex.read { () -> Int in throw AXCallError.timeout } }
        XCTAssertTrue(ex.isBusy)

        clock.withLock { $0 = 0.5 }                      // before next probe: rejected, body not run
        await expectBusy { _ = try await ex.read { ran.withLock { $0 += 1 } } }
        clock.withLock { $0 = 1.5 }                      // probe runs and fails
        await expectBusy { _ = try await ex.read { ran.withLock { $0 += 1 } } }
        healthy.withLock { $0 = true }
        clock.withLock { $0 = 2.0 }                      // healthy, but next probe is at 2.5
        await expectBusy { _ = try await ex.read { ran.withLock { $0 += 1 } } }
        clock.withLock { $0 = 2.6 }
        let v = try await ex.read { () -> Int in ran.withLock { $0 += 1 }; return 7 }
        XCTAssertEqual(v, 7)
        XCTAssertEqual(ran.withLock { $0 }, 1)
        XCTAssertFalse(ex.isBusy)
    }
}
