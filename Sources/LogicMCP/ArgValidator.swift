import LogicKit
import MCP

struct ReadArgs { var path: String; var depth: Int; var fields: [String]?; var page: String? }

enum ArgValidator {
    static func bad(_ sig: String, _ detail: String) -> LogicError { .invalidArgs(signature: sig, detail: detail) }

    static func string(_ v: Value?) -> String? {
        switch v {
        case .string(let s)?: return s
        case .int(let i)?: return String(i)
        case .double(let d)?: return String(d)
        case .bool(let b)?: return b ? "on" : "off"
        default: return nil
        }
    }

    static func onlyKeys(_ a: [String: Value], _ allowed: Set<String>, _ sig: String) throws {
        if let k = a.keys.first(where: { !allowed.contains($0) }) { throw bad(sig, "unknown argument \(k)") }
    }

    static let readSig = #"logic_read {path?: "/", depth?: 0..3, fields?: "name,mute", page?: "13-24"}"#
    static func read(_ args: [String: Value]?) throws -> ReadArgs {
        let a = args ?? [:]
        try onlyKeys(a, ["path", "depth", "fields", "page"], readSig)
        let depth = a["depth"].flatMap { $0.intValue } ?? 1
        guard (0...3).contains(depth) else { throw bad(readSig, "depth \(depth) out of 0..3") }
        return ReadArgs(path: string(a["path"]) ?? "/", depth: depth,
                        fields: string(a["fields"]).map { $0.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } },
                        page: string(a["page"]))
    }

    static let setSig = #"logic_set {assign: [{path: "track:1/mute", value: "on"}, …]} (1..32, in order)"#
    static func set(_ args: [String: Value]?) throws -> [(path: String, value: String)] {
        let a = args ?? [:]
        try onlyKeys(a, ["assign"], setSig)
        guard let items = a["assign"]?.arrayValue, (1...32).contains(items.count) else { throw bad(setSig, "assign must be a non-empty array") }
        return try items.map { item in
            guard let o = item.objectValue, let p = string(o["path"]), let v = string(o["value"]) else { throw bad(setSig, "each item needs path and value") }
            return (p, v)
        }
    }

    static let doSig = #"logic_do {path, action, args?} or {steps: [{path, action, args?}]}"#
    static func perform(_ args: [String: Value]?) throws -> [(path: String, action: String, args: [String: String])] {
        let a = args ?? [:]
        try onlyKeys(a, ["path", "action", "args", "steps"], doSig)
        func one(_ o: [String: Value]) throws -> (path: String, action: String, args: [String: String]) {
            guard let p = string(o["path"]), let act = string(o["action"]) else { throw bad(doSig, "path and action are required") }
            var extra: [String: String] = [:]
            for (k, v) in o["args"]?.objectValue ?? [:] {
                guard let s = string(v) else { throw bad(doSig, "args.\(k) must be a scalar") }
                extra[k] = s
            }
            return (p, act, extra)
        }
        if let steps = a["steps"]?.arrayValue {
            guard (1...32).contains(steps.count) else { throw bad(doSig, "steps must have 1..32 items") }
            return try steps.map { guard let o = $0.objectValue else { throw bad(doSig, "each step is an object") }; return try one(o) }
        }
        return [try one(a)]
    }

    static let midiSig = #"logic_midi {events: [{type: note|cc|pc|pitchbend, ch: 1..16, note, vel, dur_ms, cc, value, program}]}"#
    static func midi(_ args: [String: Value]?) throws -> [MIDIEvent] {
        let a = args ?? [:]
        try onlyKeys(a, ["events"], midiSig)
        guard let items = a["events"]?.arrayValue, (1...256).contains(items.count) else { throw bad(midiSig, "events must have 1..256 items") }
        return try items.map { item in
            guard let o = item.objectValue, let type = string(o["type"]) else { throw bad(midiSig, "each event needs type") }
            func i(_ k: String, _ d: Int? = nil) throws -> Int {
                if let v = o[k]?.intValue { return v }
                if let d { return d }
                throw bad(midiSig, "\(type) needs \(k)")
            }
            switch type {
            case "note": return .note(ch: try i("ch", 1), note: try i("note"), vel: try i("vel", 100), durMs: try i("dur_ms", 250))
            case "cc": return .cc(ch: try i("ch", 1), cc: try i("cc"), value: try i("value"))
            case "pc": return .pc(ch: try i("ch", 1), program: try i("program"))
            case "pitchbend": return .pitchBend(ch: try i("ch", 1), value: try i("value", 8192))
            default: throw bad(midiSig, "unknown type \(type)")
            }
        }
    }
}
