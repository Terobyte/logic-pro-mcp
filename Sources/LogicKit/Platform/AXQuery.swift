import Foundation

public struct AXMatch: Sendable, Equatable {
    public enum Op: Sendable, Equatable {
        case equals(String), prefix(String), contains(String)

        public func test(_ s: String?) -> Bool {
            guard let s else { return false }
            switch self {
            case .equals(let v): return s == v
            case .prefix(let v): return s.hasPrefix(v)
            case .contains(let v): return s.contains(v)
            }
        }
    }

    public var role: String?
    public var subrole: String?
    public var title: Op?
    public var desc: Op?
    public var help: Op?
    public var identifier: String?
    public var value: Op?

    public init(role: String? = nil, subrole: String? = nil, title: Op? = nil, desc: Op? = nil,
                help: Op? = nil, identifier: String? = nil, value: Op? = nil) {
        self.role = role; self.subrole = subrole; self.title = title; self.desc = desc
        self.help = help; self.identifier = identifier; self.value = value
    }

    public func matches(_ a: AXAttrs) -> Bool {
        if let role, a.role != role { return false }
        if let subrole, a.subrole != subrole { return false }
        if let identifier, a.identifier != identifier { return false }
        if let title, !title.test(a.title) { return false }
        if let desc, !desc.test(a.desc) { return false }
        if let help, !help.test(a.help) { return false }
        if let value, !value.test(a.value?.stringValue) { return false }
        return true
    }
}

extension AXNode {
    public func firstChild(_ m: AXMatch) throws -> (any AXNode)? {
        try children().first { try m.matches($0.attrs()) }
    }

    /// Breadth-first: the shallowest match wins.
    public func firstDescendant(_ m: AXMatch, maxDepth: Int = 12) throws -> (any AXNode)? {
        var frontier: [any AXNode] = [self]
        var depth = 0
        while !frontier.isEmpty && depth < maxDepth {
            var next: [any AXNode] = []
            for node in frontier {
                for child in try node.children() {
                    if m.matches(try child.attrs()) { return child }
                    next.append(child)
                }
            }
            frontier = next
            depth += 1
        }
        return nil
    }

    /// Depth-first pre-order. By default does not look inside a match.
    public func allDescendants(_ m: AXMatch, maxDepth: Int = 12, descendIntoMatches: Bool = false) throws -> [any AXNode] {
        var out: [any AXNode] = []
        func walk(_ node: any AXNode, _ depth: Int) throws {
            guard depth < maxDepth else { return }
            for child in try node.children() {
                let hit = m.matches(try child.attrs())
                if hit { out.append(child) }
                if !hit || descendIntoMatches { try walk(child, depth + 1) }
            }
        }
        try walk(self, 0)
        return out
    }
}

extension AXAttrs {
    /// One line per node: `role (subrole) t= d= h= id= v= vd= [sel] {Actions}` — probe output and the raw hatch (§4.7).
    public var compactLine: String {
        var parts = [role ?? "?"]
        if let subrole { parts.append("(\(subrole))") }
        if let title, !title.isEmpty { parts.append("t=\(Self.q(title))") }
        if let desc, !desc.isEmpty { parts.append("d=\(Self.q(desc))") }
        if let help, !help.isEmpty { parts.append("h=\(Self.q(String(help.prefix(60))))") }
        if let identifier, !identifier.isEmpty { parts.append("id=\(identifier)") }
        if let value { parts.append("v=\(Self.q(value.stringValue))") }
        if let valueDescription, !valueDescription.isEmpty { parts.append("vd=\(Self.q(valueDescription))") }
        if selected == true { parts.append("[sel]") }
        if enabled == false { parts.append("[disabled]") }
        let acts = actions.filter { $0 != "AXShowMenu" && $0 != "AXScrollToVisible" }
        if !acts.isEmpty {
            parts.append("{" + acts.map { $0.replacingOccurrences(of: "AX", with: "") }.joined(separator: ",") + "}")
        }
        return parts.joined(separator: " ")
    }

    static func q(_ s: String) -> String {
        "\"" + s.replacingOccurrences(of: "\"", with: "\\\"") + "\""
    }
}
