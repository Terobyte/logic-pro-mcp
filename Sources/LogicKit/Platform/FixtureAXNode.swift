import Foundation

/// Static snapshot node. Never emulates Logic behaviour: every mutation throws.
public final class FixtureAXNode: AXNode, @unchecked Sendable {
    public let snapshot: AXSnapshotNode
    private let kids: [FixtureAXNode]

    public init(_ snapshot: AXSnapshotNode) {
        self.snapshot = snapshot
        self.kids = snapshot.c.map(FixtureAXNode.init)
    }

    public func attrs() throws -> AXAttrs { snapshot.a }
    public func children() throws -> [any AXNode] { kids }
    public func perform(_ action: String) throws { throw AXCallError.readOnlyFixture }
    public func set(_ attribute: String, _ value: AXScalar) throws { throw AXCallError.readOnlyFixture }
    public var identityToken: Int { ObjectIdentifier(self).hashValue }
}

public struct FixtureAXRoot: AXRoot, @unchecked Sendable {
    private let main: FixtureAXNode?
    private let focused: FixtureAXNode?
    private let menu: FixtureAXNode?
    public let meta: AXFixture.Meta

    public init(_ fixture: AXFixture) {
        main = fixture.roots["mainWindow"].map(FixtureAXNode.init)
        focused = fixture.roots["focusedWindow"].map(FixtureAXNode.init)
        menu = fixture.roots["menuBar"].map(FixtureAXNode.init)
        meta = fixture.meta
    }

    public func mainWindow() throws -> (any AXNode)? { main }
    public func focusedWindow() throws -> (any AXNode)? { focused }
    public func menuBar() throws -> (any AXNode)? { menu }
}
