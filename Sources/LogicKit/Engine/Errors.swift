import Foundation

public enum BlockReason: Equatable, Sendable {
    case modal(String), contextChanged(String), recording, playing
}

public enum LogicError: Error, Equatable, Sendable {
    case notFound(String, candidates: [String])
    case ambiguous(String, candidates: [String])
    case staleRef(String)
    case blocked(BlockReason)
    case busy(String)
    case unavailable(String)
    case unsupported(String)
    case needSelect(track: Int)
    case invalidArgs(signature: String, detail: String)
    case invalidValue(want: String, range: String)
    case verifyFailed(want: String, got: String)
    case timeout(last: String?)
    case partial(done: [String], failed: String, undoSteps: Int?)
    case confirmRequired(String)
    case permissionAX
    case logicNotRunning
    case anchorMissing(String)
    case needMMCInput

    public var code: String {
        switch self {
        case .notFound: return "not_found"
        case .ambiguous: return "ambiguous"
        case .staleRef: return "stale_ref"
        case .blocked: return "blocked"
        case .busy: return "busy"
        case .unavailable: return "unavailable"
        case .unsupported: return "unsupported"
        case .needSelect: return "need_select"
        case .invalidArgs: return "invalid_args"
        case .invalidValue: return "invalid_value"
        case .verifyFailed: return "verify_failed"
        case .timeout: return "timeout"
        case .partial: return "partial"
        case .confirmRequired: return "confirm_required"
        case .permissionAX: return "permission"
        case .logicNotRunning: return "logic_not_running"
        case .anchorMissing: return "anchor_missing"
        case .needMMCInput: return "need_mmc_input"
        }
    }

    /// Spec §5.5: first line ≤ 60 tokens, whole text ≤ 150, at most 5 candidates.
    public var text: String {
        let (head, extra) = parts
        var lines = [Self.clip(head, tokens: 60)] + extra.map { Self.clip($0, tokens: 90) }
        while lines.count > 1 && TokenEstimate.count(lines.joined(separator: "\n")) > 150 { lines.removeLast() }
        return lines.joined(separator: "\n")
    }

    private var parts: (String, [String]) {
        switch self {
        case .notFound(let what, let c): return ("not_found: \(what)", Self.candidates(c))
        case .ambiguous(let what, let c): return ("ambiguous: \(what) matches \(c.count)", Self.candidates(c))
        case .staleRef(let h): return ("stale_ref: \(h) — re-read the parent and use the new address", [])
        case .blocked(.modal(let t)): return ("blocked: modal \"\(t)\" is open — close it in Logic or wait", [])
        case .blocked(.contextChanged(let s)): return ("blocked: context changed (\(s)) — operation stopped", [])
        case .blocked(.recording): return ("blocked: Logic is recording — only transport stop is allowed", [])
        case .blocked(.playing): return ("blocked: Logic is playing — stop transport first", [])
        case .busy(let r): return ("busy: \(r) — retry later", [])
        case .unavailable(let r): return ("unavailable: \(r)", [])
        case .unsupported(let r): return ("unsupported: \(r)", [])
        case .needSelect(let n): return ("need_select: select track \(n) first (logic_do track:\(n) select)", [])
        case .invalidArgs(let sig, let detail): return ("invalid_args: \(detail)", ["signature: \(sig)"])
        case .invalidValue(let want, let range): return ("invalid_value: \(want) outside \(range)", [])
        case .verifyFailed(let want, let got): return ("verify_failed: want \(want), got \(got)", [])
        case .timeout(let last): return ("timeout" + (last.map { " (last: \($0))" } ?? ""), [])
        case .partial(let done, let failed, let undo):
            var extra = ["done: " + done.joined(separator: "; ")]
            if let undo { extra.append("undo_steps: \(undo)") }
            return ("partial: \(done.count) done, failed: \(failed)", extra)
        case .confirmRequired(let c): return ("confirm_required: \(c) — repeat with confirm:true", [])
        case .permissionAX: return ("permission: Accessibility not granted — System Settings › Privacy & Security › Accessibility", [])
        case .logicNotRunning: return ("logic_not_running: start Logic Pro", [])
        case .anchorMissing(let a): return ("anchor_missing: \(a) — this Logic UI differs; capability disabled", [])
        case .needMMCInput: return ("need_mmc_input: enable Project Settings › Synchronization › MIDI › Listen to MMC Input", [])
        }
    }

    static func candidates(_ c: [String]) -> [String] {
        c.isEmpty ? [] : ["candidates: " + c.prefix(5).map { String($0.prefix(40)) }.joined(separator: " · ")]
    }

    static func clip(_ s: String, tokens: Int) -> String {
        guard TokenEstimate.count(s) > tokens else { return s }
        var out = s
        while TokenEstimate.count(out + "…") > tokens { out.removeLast() }
        return out + "…"
    }
}

public struct Quantization: Equatable, Sendable {
    public var want: String
    public var step: String
    public init(want: String, step: String) { self.want = want; self.step = step }
}

public enum Outcome: Equatable, Sendable {
    case ok(path: String, actual: String, quantized: Quantization? = nil, notes: [String] = [])
    case sent(String)
    case unverified(String)

    public var text: String {
        switch self {
        case .ok(let path, let actual, let q, let notes):
            var s = "✓ \(path) = \(actual)"
            if let q { s += " (want \(q.want), step \(q.step))" }
            return ([s] + notes).joined(separator: "\n")
        case .sent(let s): return "→ sent \(s)"
        case .unverified(let s): return "? unverified \(s)"
        }
    }

    public func appending(notes more: [String]) -> Outcome {
        guard !more.isEmpty, case .ok(let p, let a, let q, let n) = self else { return self }
        return .ok(path: p, actual: a, quantized: q, notes: n + more)
    }
}
