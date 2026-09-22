import Foundation
import os

public enum ExecutorError: Error, Equatable, Sendable {
    case busy
    case shutDown
}

/// Spec §5.1: every AX call runs on one dedicated thread with its own CFRunLoop (AXObserver sources
/// attach here later). Jobs are synchronous closures executed FIFO, so a transaction — including its
/// verify waits — can never interleave with another job. A call that times out marks Logic busy:
/// later jobs fail fast with `.busy` until a health probe (at most once per `busyProbeInterval`) passes.
public final class AXExecutor: @unchecked Sendable {
    public static let threadName = "logickit.ax"

    public struct Config: Sendable {
        public var busyProbeInterval: Double = 1.0
        public init() {}
    }

    private final class AXThread: Thread, @unchecked Sendable {
        var runLoop: CFRunLoop?
        let ready = DispatchSemaphore(value: 0)

        override func main() {
            runLoop = CFRunLoopGetCurrent()
            var ctx = CFRunLoopSourceContext()
            let keepAlive = CFRunLoopSourceCreate(nil, 0, &ctx)
            CFRunLoopAddSource(runLoop, keepAlive, .defaultMode)
            ready.signal()
            while !isCancelled {
                _ = CFRunLoopRunInMode(.defaultMode, 0.5, false)
            }
        }
    }

    private struct BusyState {
        var busy = false
        var nextProbe = 0.0
    }

    private let thread = AXThread()
    private let config: Config
    private let probe: @Sendable () -> Bool
    private let now: @Sendable () -> Double
    private let state = OSAllocatedUnfairLock(initialState: BusyState())

    public init(config: Config = .init(),
                now: @escaping @Sendable () -> Double = { ProcessInfo.processInfo.systemUptime },
                healthProbe: @escaping @Sendable () -> Bool) {
        self.config = config
        self.probe = healthProbe
        self.now = now
        thread.name = Self.threadName
        thread.start()
        thread.ready.wait()
    }

    public var runLoop: CFRunLoop { thread.runLoop! }
    public var isBusy: Bool { state.withLock { $0.busy } }

    /// Short slot: a single read (or one poll iteration).
    public func read<T: Sendable>(_ body: @escaping @Sendable () throws -> T) async throws -> T {
        try await submit(body)
    }

    /// Mutation transaction: runs to completion on the AX thread; nothing else runs in between.
    public func transaction<T: Sendable>(_ body: @escaping @Sendable () throws -> T) async throws -> T {
        try await submit(body)
    }

    public func shutdown() {
        thread.cancel()
        CFRunLoopWakeUp(runLoop)
    }

    private func submit<T: Sendable>(_ body: @escaping @Sendable () throws -> T) async throws -> T {
        guard !thread.isCancelled else { throw ExecutorError.shutDown }
        let loop = runLoop
        return try await withCheckedThrowingContinuation { (cont: CheckedContinuation<T, Error>) in
            CFRunLoopPerformBlock(loop, CFRunLoopMode.defaultMode.rawValue) {
                cont.resume(with: Result { try self.run(body) })
            }
            CFRunLoopWakeUp(loop)
        }
    }

    private func run<T>(_ body: () throws -> T) throws -> T {
        let t = now()
        let interval = config.busyProbeInterval
        // nil → run normally; false → reject; true → probe first
        let gate: Bool? = state.withLock { s in
            guard s.busy else { return nil }
            if t < s.nextProbe { return false }
            s.nextProbe = t + interval
            return true
        }
        if gate == false { throw ExecutorError.busy }
        if gate == true {
            guard probe() else { throw ExecutorError.busy }
            state.withLock { $0.busy = false }
        }
        do {
            return try body()
        } catch AXCallError.timeout {
            let t2 = now()
            state.withLock { $0.busy = true; $0.nextProbe = t2 + interval }
            throw ExecutorError.busy
        }
    }
}
