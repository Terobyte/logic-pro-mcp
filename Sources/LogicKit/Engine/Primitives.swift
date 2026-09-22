import Foundation

public struct Clock: Sendable {
    public var now: @Sendable () -> Double
    public var sleep: @Sendable (Double) -> Void
    public init(now: @escaping @Sendable () -> Double, sleep: @escaping @Sendable (Double) -> Void) { self.now = now; self.sleep = sleep }
    public static let system = Clock(now: { ProcessInfo.processInfo.systemUptime }, sleep: { Thread.sleep(forTimeInterval: $0) })
}

public enum Verify {
    /// Spec §5.1: re-read every 30 ms until `done` or the deadline. Never throws on timeout; returns the last value.
    public static func poll<T>(deadline: Double, interval: Double = 0.03, clock: Clock,
                               read: () throws -> T, done: (T) -> Bool) throws -> (value: T, ok: Bool) {
        var v = try read()
        while !done(v) {
            guard clock.now() < deadline else { return (v, false) }
            clock.sleep(interval)
            v = try read()
        }
        return (v, true)
    }
}

public struct StepResult: Equatable, Sendable {
    public var start: Double
    public var actual: Double
    public var actualText: String
    public var lastStep: Double?
    public var steps: Int
}

public enum Primitives {
    public static func press(_ n: any AXNode) throws { try n.perform("AXPress") }

    /// Text only through AXValue (spec §1: independent of keyboard layout).
    public static func setText(_ n: any AXNode, _ text: String) throws {
        try n.set("AXValue", .string(text))
        if try n.attrs().actions.contains("AXConfirm") { try n.perform("AXConfirm") }
    }

    public static func menu(_ bar: any AXNode, _ path: [String]) throws {
        guard let item = try MenuPath.resolve(menuBar: bar, path: path) else { throw LogicError.anchorMissing("menu " + path.joined(separator: ">")) }
        guard try item.attrs().enabled != false else { throw LogicError.unavailable("menu \(path.joined(separator: ">")) is disabled") }
        try item.perform("AXPress")
    }

    /// Spec §5.2: AXIncrement/AXDecrement reading AXValueDescription; stops at the reachable value nearest the target.
    public static func stepTo(_ n: any AXNode, target: Double, parse: (String) -> Double?, clock: Clock,
                              perStepDeadline: Double = 0.5, maxSteps: Int = 400) throws -> StepResult {
        func read() throws -> (Double, String) {
            guard let t = try n.attrs().valueDescription, let v = parse(t) else { throw LogicError.unavailable("control value is unreadable") }
            return (v, t)
        }
        var (cur, curText) = try read()
        let start = cur
        if cur == target { return StepResult(start: start, actual: cur, actualText: curText, lastStep: nil, steps: 0) }
        let up = target > cur
        var lastStep: Double?
        var steps = 0
        while steps < maxSteps {
            try n.perform(up ? "AXIncrement" : "AXDecrement")
            steps += 1
            let before = cur
            let r = try Verify.poll(deadline: clock.now() + perStepDeadline, clock: clock, read: read, done: { $0.0 != before })
            guard r.ok else { break }   // did not move: at the control's limit
            let (nv, nt) = r.value
            if (nv > cur) != up { throw LogicError.verifyFailed(want: "move \(up ? "up" : "down")", got: nt) }
            lastStep = abs(nv - cur)
            if up ? nv >= target : nv <= target {
                if abs(cur - target) < abs(nv - target) {
                    try n.perform(up ? "AXDecrement" : "AXIncrement")
                    steps += 1
                    let back = try Verify.poll(deadline: clock.now() + perStepDeadline, clock: clock, read: read, done: { $0.0 != nv })
                    return StepResult(start: start, actual: back.value.0, actualText: back.value.1, lastStep: lastStep, steps: steps)
                }
                return StepResult(start: start, actual: nv, actualText: nt, lastStep: lastStep, steps: steps)
            }
            cur = nv; curText = nt
        }
        return StepResult(start: start, actual: cur, actualText: curText, lastStep: lastStep, steps: steps)
    }
}

public enum StepContract {
    /// ok if the control moved and ended within one step of the target; quantized when not exact.
    public static func judge(want: Double, wantText: String, result: StepResult, format: (Double) -> String) throws -> Quantization? {
        if result.actual == want { return nil }
        guard let step = result.lastStep, abs(want - result.actual) <= step + 1e-9 else {
            throw LogicError.verifyFailed(want: wantText, got: result.actualText)
        }
        return Quantization(want: wantText, step: format(step))
    }
}
