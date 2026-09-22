import Foundation

public struct LocatorError: Error, Equatable, CustomStringConvertible {
    public let message: String
    public init(_ message: String) { self.message = message }
    public var description: String { message }
}

public struct AXLocator: Equatable, Sendable {
    public struct Step: Equatable, Sendable {
        public var match: AXMatch
        public var index: Int
    }

    public var steps: [Step]

    public static func parse(_ s: String) throws -> AXLocator {
        var steps: [Step] = []
        for raw in s.components(separatedBy: " > ") {
            var text = raw.trimmingCharacters(in: .whitespaces)
            var index = 0
            if let r = text.range(of: #"\[(\d+)\]$"#, options: .regularExpression) {
                index = Int(text[r].dropFirst().dropLast())!
                text.removeSubrange(r)
            }
            var m = AXMatch()
            for field in text.split(separator: ";") {
                let (key, op, value) = try split(String(field))
                let o: AXMatch.Op = op == "^=" ? .prefix(value) : op == "~=" ? .contains(value) : .equals(value)
                switch key {
                case "role", "subrole", "id":
                    guard op == "=" else { throw LocatorError("\(key) accepts only '='") }
                    if key == "role" { m.role = value } else if key == "subrole" { m.subrole = value } else { m.identifier = value }
                case "title": m.title = o
                case "desc": m.desc = o
                case "help": m.help = o
                case "value": m.value = o
                default: throw LocatorError("unknown key \(key)")
                }
            }
            steps.append(Step(match: m, index: index))
        }
        return AXLocator(steps: steps)
    }

    private static func split(_ field: String) throws -> (String, String, String) {
        for op in ["^=", "~=", "="] {
            if let r = field.range(of: op) {
                let key = field[..<r.lowerBound].trimmingCharacters(in: .whitespaces)
                return (key, op, String(field[r.upperBound...]))
            }
        }
        throw LocatorError("bad field '\(field)': expected key=value, key^=value or key~=value")
    }

    public func resolve(from root: any AXNode, maxDepth: Int = 12) throws -> (any AXNode)? {
        var current: any AXNode = root
        for step in steps {
            let hits = try current.allDescendants(step.match, maxDepth: maxDepth)
            guard step.index < hits.count else { return nil }
            current = hits[step.index]
        }
        return current
    }

    /// All matches of the last step under the node chosen by the previous steps.
    public func resolveAll(from root: any AXNode, maxDepth: Int = 12) throws -> [any AXNode] {
        guard let last = steps.last else { return [] }
        guard let parent = try AXLocator(steps: Array(steps.dropLast())).resolve(from: root, maxDepth: maxDepth) else { return [] }
        return try parent.allDescendants(last.match, maxDepth: maxDepth)
    }
}
