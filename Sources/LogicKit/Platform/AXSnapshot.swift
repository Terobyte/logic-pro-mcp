import Foundation

public struct AXSnapshotNode: Codable, Equatable, Sendable {
    public var a: AXAttrs
    public var c: [AXSnapshotNode]
    /// true when capture stopped at the depth limit; the node may have had children.
    public var truncated: Bool?

    public init(a: AXAttrs, c: [AXSnapshotNode], truncated: Bool? = nil) {
        self.a = a; self.c = c; self.truncated = truncated
    }
}

public struct AXFixture: Codable, Sendable {
    public struct Meta: Codable, Sendable {
        public var logicVersion: String
        public var capturedAt: String
        public var project: String
        public var note: String?
        public init(logicVersion: String, capturedAt: String, project: String, note: String? = nil) {
            self.logicVersion = logicVersion; self.capturedAt = capturedAt; self.project = project; self.note = note
        }
    }

    public var meta: Meta
    /// Keys: "mainWindow", "menuBar", "focusedWindow".
    public var roots: [String: AXSnapshotNode]

    public init(meta: Meta, roots: [String: AXSnapshotNode]) {
        self.meta = meta; self.roots = roots
    }

    public static func load(_ url: URL) throws -> AXFixture {
        try JSONDecoder().decode(AXFixture.self, from: Data(contentsOf: url))
    }

    public func write(to url: URL) throws {
        let e = JSONEncoder()
        e.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        try e.encode(self).write(to: url)
    }
}

public struct CaptureStats: Sendable {
    public var nodes = 0
    public var truncatedAt = 0
    public var skipped = 0
    public init() {}
}

public enum AXCapture {
    /// Depth-first capture. Vanished children are skipped; timeouts propagate.
    public static func capture(_ node: any AXNode, depth: Int, stats: inout CaptureStats) throws -> AXSnapshotNode {
        let a = try node.attrs()
        stats.nodes += 1
        guard depth > 0 else {
            stats.truncatedAt += 1
            return AXSnapshotNode(a: a, c: [], truncated: true)
        }
        var kids: [AXSnapshotNode] = []
        for child in try node.children() {
            do {
                kids.append(try capture(child, depth: depth - 1, stats: &stats))
            } catch AXCallError.invalidElement {
                stats.skipped += 1
            }
        }
        return AXSnapshotNode(a: a, c: kids)
    }
}
