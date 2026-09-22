import Foundation
import os

public struct Fingerprint: Hashable, Sendable {
    public var kind: NodeKind
    public var number: Int?
    public var name: String
    public var parent: String
    public var prev: String?
    public var next: String?
    public init(kind: NodeKind, number: Int?, name: String, parent: String, prev: String?, next: String?) {
        self.kind = kind; self.number = number; self.name = name; self.parent = parent; self.prev = prev; self.next = next
    }
}

public enum HandleMatch: Equatable, Sendable { case exact(Int), moved(Int), stale }

/// Spec §4.4. Handles guard against hitting the wrong node; they are not a guarantee.
public final class HandleTable: Sendable {
    private struct State { var byHandle: [String: Fingerprint] = [:]; var byPrint: [Fingerprint: String] = [:] }
    private let state = OSAllocatedUnfairLock(initialState: State())

    public init() {}

    public func handle(for fp: Fingerprint) -> String {
        state.withLock { s in
            if let h = s.byPrint[fp] { return h }
            let prefix = NodeKind.handlePrefixes.first { $0.value == fp.kind }.map { String($0.key) } ?? "n"
            let hex = String(Self.fnv1a("\(fp.kind.rawValue)|\(fp.number ?? -1)|\(fp.name)|\(fp.parent)|\(fp.prev ?? "")|\(fp.next ?? "")"), radix: 16)
            var len = 4
            var h = "#" + prefix + String(hex.prefix(len))
            while let other = s.byHandle[h], other != fp, len < hex.count { len += 2; h = "#" + prefix + String(hex.prefix(len)) }
            s.byHandle[h] = fp
            s.byPrint[fp] = h
            return h
        }
    }

    public func fingerprint(_ handle: String) -> Fingerprint? { state.withLock { $0.byHandle[handle] } }

    /// After any structural mutation (create/delete/undo/redo/project change).
    public func reset() { state.withLock { $0 = State() } }

    public static func match(_ fp: Fingerprint, in candidates: [Fingerprint]) -> HandleMatch {
        if let i = candidates.firstIndex(of: fp) { return .exact(i) }
        let same = candidates.indices.filter {
            let c = candidates[$0]
            return c.kind == fp.kind && c.parent == fp.parent && c.prev == fp.prev && c.next == fp.next
        }
        return same.count == 1 ? .moved(same[0]) : .stale
    }

    static func fnv1a(_ s: String) -> UInt64 {
        var h: UInt64 = 0xcbf29ce484222325
        for b in s.utf8 { h = (h ^ UInt64(b)) &* 0x100000001b3 }
        return h
    }
}
