import Foundation

public enum CapabilityStatus: String, Codable, Sendable { case planned, recipe }

public struct Capability: Hashable, Sendable {
    public enum Form: Hashable, Sendable { case read, property(ValueUnit), action(signature: String) }
    public var kind: NodeKind
    public var name: String
    public var form: Form
    public var status: CapabilityStatus
    public var liveTest: String?
    public var key: String { "\(kind == .root ? "root" : kind.rawValue).\(name)" }
}

public enum Grammar {
    /// P1 slice (spec §11). Entries whose spike was red are set to `.planned` in Task 16/28.
    public static let all: [Capability] = [
        .init(kind: .root, name: "read", form: .read, status: .recipe, liveTest: "LiveReadTests/testReadRoot"),
        .init(kind: .track, name: "read", form: .read, status: .recipe, liveTest: "LiveReadTests/testReadTrack"),
        .init(kind: .strip, name: "read", form: .read, status: .recipe, liveTest: "LiveReadTests/testReadSelectedStrip"),
        .init(kind: .transport, name: "read", form: .read, status: .recipe, liveTest: "LiveReadTests/testReadTransport"),
        .init(kind: .track, name: "mute", form: .property(.onOff), status: .recipe, liveTest: "LiveTrackTests/testMuteRoundTrip"),
        .init(kind: .track, name: "solo", form: .property(.onOff), status: .recipe, liveTest: "LiveTrackTests/testSoloRoundTrip"),
        .init(kind: .track, name: "select", form: .action(signature: "select"), status: .recipe, liveTest: "LiveTrackTests/testSelectAndRestore"),
        .init(kind: .root, name: "undo", form: .action(signature: "undo {steps?: 1..10}"), status: .recipe, liveTest: "LiveUndoTests/testUndoRedoNewTrack"),
        .init(kind: .root, name: "redo", form: .action(signature: "redo {steps?: 1..10}"), status: .recipe, liveTest: "LiveUndoTests/testUndoRedoNewTrack"),
        .init(kind: .transport, name: "play", form: .action(signature: "play"), status: .recipe, liveTest: "LiveTransportTests/testPlayStop"),
        .init(kind: .transport, name: "stop", form: .action(signature: "stop"), status: .recipe, liveTest: "LiveTransportTests/testPlayStop"),
        .init(kind: .transport, name: "position", form: .property(.position), status: .recipe, liveTest: "LiveTransportTests/testLocate"),
    ]

    public static func find(_ kind: NodeKind, _ name: String) -> Capability? {
        all.first { $0.kind == kind && $0.name == name }
    }

    public static func advertised(ledger: Ledger, logicMinor: String?) -> [Capability] {
        guard let minor = logicMinor ?? ledger.latestMinor else { return [] }
        return all.filter { $0.status == .recipe && ledger.passed($0, minor: minor) }
    }

    /// One line per kind for the logic_read description (spec §4.8).
    public static func index(_ caps: [Capability]) -> String {
        var order: [NodeKind] = []
        var byKind: [NodeKind: [String]] = [:]
        for c in caps {
            if byKind[c.kind] == nil { order.append(c.kind) }
            let word: String
            switch c.form {
            case .read: word = "read"
            case .property(.onOff): word = "\(c.name)=on|off"
            case .property(let u): word = "\(c.name)=<\(u.rawValue)>"
            case .action: word = "\(c.name)()"
            }
            byKind[c.kind, default: []].append(word)
        }
        return order.map { "\($0.rawValue): " + byKind[$0]!.joined(separator: ", ") }.joined(separator: " · ")
    }

    public static func schema(_ kind: NodeKind, caps: [Capability]) -> String {
        let lines = caps.filter { $0.kind == kind }.map { c -> String in
            let node = kind == .root ? "/" : kind == .track ? "track:N" : kind.rawValue
            switch c.form {
            case .read: return "\(c.key): logic_read \(node)"
            case .property(let u): return "\(c.key): logic_set \(node)/\(c.name) = <\(u.rawValue)>"
            case .action(let sig): return "\(c.key): logic_do \(node) \(sig)"
            }
        }
        return lines.isEmpty ? "schema \(kind.rawValue): no live-verified capabilities" : lines.joined(separator: "\n")
    }
}

public struct LedgerEntry: Codable, Equatable, Sendable {
    public var capability: String
    public var logicVersion: String
    public var date: String
    public var test: String
    public var result: String
}

/// Spec §5.6: written only by LogicLiveTests; read at runtime to decide what is advertised.
public struct Ledger: Codable, Sendable {
    public var entries: [LedgerEntry]
    public init(entries: [LedgerEntry]) { self.entries = entries }

    public static func bundled() -> Ledger {
        guard let url = Bundle.module.url(forResource: "ledger", withExtension: "json") else { return Ledger(entries: []) }
        return (try? load(url)) ?? Ledger(entries: [])
    }

    public static func load(_ url: URL) throws -> Ledger { try JSONDecoder().decode(Ledger.self, from: Data(contentsOf: url)) }

    public func write(to url: URL) throws {
        let e = JSONEncoder()
        e.outputFormatting = [.prettyPrinted, .sortedKeys]
        try e.encode(self).write(to: url)
    }

    public var latestMinor: String? {
        entries.map { LogicApp.minor($0.logicVersion) }.max { a, b in
            a.split(separator: ".").compactMap { Int($0) }.lexicographicallyPrecedes(b.split(separator: ".").compactMap { Int($0) })
        }
    }

    public func passed(_ c: Capability, minor: String) -> Bool {
        entries.contains { $0.capability == c.key && LogicApp.minor($0.logicVersion) == minor && $0.result == "pass" }
    }

    public mutating func record(_ c: Capability, version: String, date: String) {
        entries.removeAll { $0.capability == c.key && LogicApp.minor($0.logicVersion) == LogicApp.minor(version) }
        entries.append(LedgerEntry(capability: c.key, logicVersion: version, date: date, test: c.liveTest ?? "", result: "pass"))
        entries.sort { ($0.capability, $0.logicVersion) < ($1.capability, $1.logicVersion) }
    }
}
