import Foundation

/// A scalar AX value. Encoded in fixtures as a bare JSON bool/number/string.
public enum AXScalar: Codable, Equatable, Sendable {
    case string(String)
    case number(Double)
    case bool(Bool)

    public var stringValue: String {
        switch self {
        case .string(let s): return s
        case .bool(let b): return b ? "1" : "0"
        case .number(let d):
            if d == d.rounded(), abs(d) < 1e15 { return String(Int64(d)) }
            return String(d)
        }
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let b = try? c.decode(Bool.self) { self = .bool(b); return }
        if let d = try? c.decode(Double.self) { self = .number(d); return }
        self = .string(try c.decode(String.self))
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch self {
        case .string(let s): try c.encode(s)
        case .number(let d): try c.encode(d)
        case .bool(let b): try c.encode(b)
        }
    }
}

/// The attribute set read in one batch per node.
public struct AXAttrs: Codable, Equatable, Sendable {
    public var role: String?
    public var subrole: String?
    public var title: String?
    public var desc: String?
    public var help: String?
    public var identifier: String?
    public var value: AXScalar?
    public var valueDescription: String?
    public var enabled: Bool?
    public var selected: Bool?
    public var actions: [String]

    public init(role: String? = nil, subrole: String? = nil, title: String? = nil, desc: String? = nil,
                help: String? = nil, identifier: String? = nil, value: AXScalar? = nil,
                valueDescription: String? = nil, enabled: Bool? = nil, selected: Bool? = nil,
                actions: [String] = []) {
        self.role = role; self.subrole = subrole; self.title = title; self.desc = desc
        self.help = help; self.identifier = identifier; self.value = value
        self.valueDescription = valueDescription; self.enabled = enabled; self.selected = selected
        self.actions = actions
    }

    enum CodingKeys: String, CodingKey {
        case role, subrole, title, desc, help, identifier, value, valueDescription, enabled, selected, actions
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        role = try c.decodeIfPresent(String.self, forKey: .role)
        subrole = try c.decodeIfPresent(String.self, forKey: .subrole)
        title = try c.decodeIfPresent(String.self, forKey: .title)
        desc = try c.decodeIfPresent(String.self, forKey: .desc)
        help = try c.decodeIfPresent(String.self, forKey: .help)
        identifier = try c.decodeIfPresent(String.self, forKey: .identifier)
        value = try c.decodeIfPresent(AXScalar.self, forKey: .value)
        valueDescription = try c.decodeIfPresent(String.self, forKey: .valueDescription)
        enabled = try c.decodeIfPresent(Bool.self, forKey: .enabled)
        selected = try c.decodeIfPresent(Bool.self, forKey: .selected)
        actions = try c.decodeIfPresent([String].self, forKey: .actions) ?? []
    }
}

public enum AXCallError: Error, Equatable, Sendable {
    /// kAXErrorCannotComplete or the messaging timeout: Logic's main thread did not answer.
    case timeout
    case invalidElement
    case notSupported(String)
    case failure(Int32)
    case readOnlyFixture
}

/// All AX access goes through this protocol (spec §3). Live and fixture implementations.
public protocol AXNode: AnyObject, Sendable {
    func attrs() throws -> AXAttrs
    func children() throws -> [any AXNode]
    func perform(_ action: String) throws
    func set(_ attribute: String, _ value: AXScalar) throws
    /// Equal for the same UI element within one AX session.
    var identityToken: Int { get }
}

public protocol AXRoot: Sendable {
    func mainWindow() throws -> (any AXNode)?
    func focusedWindow() throws -> (any AXNode)?
    func menuBar() throws -> (any AXNode)?
}
