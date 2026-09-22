import Foundation

public enum NodeKind: String, CaseIterable, Sendable {
    case root = "/", transport, track, strip, insert, param, send, meter, take, region, master, marker, patches, render, ui, system, schema, raw

    var needsSelector: Bool { [.track, .insert, .param, .send, .take, .marker, .render, .schema].contains(self) }
    var forbidsSelector: Bool { [.transport, .strip, .meter, .master, .patches, .ui, .system].contains(self) }
    /// Bare selector words are ids for these kinds, names otherwise.
    var bareIsID: Bool { [.render, .raw, .schema].contains(self) }
    static let handlePrefixes: [Character: NodeKind] = ["t": .track, "i": .insert, "s": .send, "k": .take, "r": .region, "m": .marker]
}

public enum Selector: Equatable, Sendable {
    case number(Int), name(String), selected, handle(String), id(String)
}

public struct PathSegment: Equatable, Sendable {
    public var kind: NodeKind
    public var selector: Selector?
    public var position: String?

    public init(_ kind: NodeKind, _ selector: Selector? = nil, position: String? = nil) {
        self.kind = kind; self.selector = selector; self.position = position
    }

    var text: String {
        if kind == .schema, case .id(let k)? = selector { return "schema/\(k)" }
        var s = kind.rawValue
        switch selector {
        case .number(let n)?: s += ":\(n)"
        case .name(let n)?: s += ":\"\(n.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\""))\""
        case .selected?: s += ":selected"
        case .handle(let h)?: s += ":\(h)"
        case .id(let i)?: s += ":\(i)"
        case nil: break
        }
        if let position { s += "@\"\(position)\"" }
        return s
    }
}

public struct LPath: Equatable, Sendable, CustomStringConvertible {
    public var segments: [PathSegment]
    public var property: String?

    public init(segments: [PathSegment] = [], property: String? = nil) {
        self.segments = segments; self.property = property
    }

    public static let grammar = #"path := segment ("/" segment)* ["/" property]; segment := kind[:selector|@position]; selector := N | "name" | selected | #handle"#

    public var description: String {
        var parts = segments.map(\.text)
        if let property { parts.append(property) }
        return parts.isEmpty ? "/" : parts.joined(separator: "/")
    }

    static func bad(_ detail: String) -> LogicError { .invalidArgs(signature: grammar, detail: detail) }

    public static func parse(_ input: String) throws -> LPath {
        var s = input.trimmingCharacters(in: .whitespaces)
        if s.hasPrefix("/") { s.removeFirst() }
        if s.isEmpty { return LPath() }
        let tokens = try split(s)
        var out = LPath()
        var i = 0
        while i < tokens.count {
            let tok = tokens[i]
            let isLast = i == tokens.count - 1
            if tok.hasPrefix("#") {
                guard let c = tok.dropFirst().first, let kind = NodeKind.handlePrefixes[c] else { throw bad("unknown handle \(tok)") }
                out.segments.append(PathSegment(kind, .handle(tok)))
                i += 1; continue
            }
            let name = String(tok.prefix(while: { $0.isLetter || $0 == "_" }))
            let rest = tok.dropFirst(name.count)
            guard let kind = NodeKind(rawValue: name), kind != .root else {
                if isLast, rest.isEmpty, !name.isEmpty, !out.segments.isEmpty {
                    out.property = name; i += 1; continue
                }
                throw bad("unknown kind '\(name)' in \(input)")
            }
            var seg = PathSegment(kind)
            if kind == .schema {
                guard rest.isEmpty, i + 1 < tokens.count, NodeKind(rawValue: tokens[i + 1]) != nil else { throw bad("expected system/schema/<kind>") }
                seg.selector = .id(tokens[i + 1])
                out.segments.append(seg); i += 2; continue
            }
            if rest.hasPrefix(":") {
                seg.selector = try selector(String(rest.dropFirst()), kind: kind)
            } else if rest.hasPrefix("@") {
                seg.position = try unquote(String(rest.dropFirst()))
            } else if !rest.isEmpty {
                throw bad("unexpected '\(rest)' after \(name)")
            }
            if kind.forbidsSelector && (seg.selector != nil || seg.position != nil) { throw bad("\(name) takes no selector") }
            if kind.needsSelector && seg.selector == nil { throw bad("\(name) needs a selector, e.g. \(name):3 or \(name):\"Name\"") }
            if kind == .region && seg.selector == nil && seg.position == nil { throw bad("region needs @\"bar beat div tick\" or :\"name\"") }
            out.segments.append(seg)
            i += 1
        }
        if out.property != nil, out.segments.isEmpty { throw bad("property without a node") }
        return out
    }

    /// Splits on "/" outside double quotes.
    static func split(_ s: String) throws -> [String] {
        var tokens: [String] = [], cur = "", inQuote = false, escape = false
        for ch in s {
            if escape { cur.append(ch); escape = false; continue }
            if ch == "\\" && inQuote { cur.append(ch); escape = true; continue }
            if ch == "\"" { inQuote.toggle() }
            if ch == "/" && !inQuote { tokens.append(cur); cur = ""; continue }
            cur.append(ch)
        }
        guard !inQuote else { throw bad("unterminated quote in \(s)") }
        tokens.append(cur)
        guard !tokens.contains(where: \.isEmpty) else { throw bad("empty segment in \(s)") }
        return tokens
    }

    static func unquote(_ s: String) throws -> String {
        guard s.hasPrefix("\"") else { return s }
        guard s.count >= 2, s.hasSuffix("\"") else { throw bad("unterminated quote") }
        var out = "", escape = false
        for ch in s.dropFirst().dropLast() {
            if escape { out.append(ch); escape = false } else if ch == "\\" { escape = true } else { out.append(ch) }
        }
        return out
    }

    static func selector(_ raw: String, kind: NodeKind) throws -> Selector {
        guard !raw.isEmpty else { throw bad("empty selector for \(kind.rawValue)") }
        if raw.hasPrefix("\"") { return .name(try unquote(raw)) }
        if let n = Int(raw) { return .number(n) }
        if raw == "selected" { return .selected }
        if raw.hasPrefix("#") { return .handle(raw) }
        return kind.bareIsID ? .id(raw) : .name(raw)
    }
}
