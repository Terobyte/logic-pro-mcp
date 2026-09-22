import ApplicationServices
import Foundation
import os

/// Counts AX IPC messages (spec §7 time/AX budgets).
public final class AXStats: Sendable {
    public static let shared = AXStats()
    private let state = OSAllocatedUnfairLock(initialState: (messages: 0, timeouts: 0))

    public init() {}
    /// IPC budget counter. Negative counts are ignored so a bad caller cannot shrink the budget.
    public func message(_ n: Int = 1) {
        guard n > 0 else { return }
        state.withLock { $0.messages += n }
    }
    public func timeout() { state.withLock { $0.timeouts += 1 } }
    public var messages: Int { state.withLock { $0.messages } }
    public var timeouts: Int { state.withLock { $0.timeouts } }
    public func reset() { state.withLock { $0 = (0, 0) } }
}

func axCheck(_ err: AXError) throws {
    switch err {
    case .success: return
    case .cannotComplete:
        AXStats.shared.timeout()
        throw AXCallError.timeout
    case .invalidUIElement: throw AXCallError.invalidElement
    case .attributeUnsupported, .actionUnsupported, .noValue, .parameterizedAttributeUnsupported:
        throw AXCallError.notSupported("AXError \(err.rawValue)")
    default: throw AXCallError.failure(err.rawValue)
    }
}

public final class LiveAXNode: AXNode, @unchecked Sendable {
    public let element: AXUIElement
    let timeout: Float

    public init(_ element: AXUIElement, timeout: Float = 1.0) {
        self.element = element
        self.timeout = timeout
        AXUIElementSetMessagingTimeout(element, timeout)
    }

    static let batchNames: [String] = [
        kAXRoleAttribute, kAXSubroleAttribute, kAXTitleAttribute, kAXDescriptionAttribute,
        kAXHelpAttribute, kAXIdentifierAttribute, kAXValueAttribute, "AXValueDescription",
        kAXEnabledAttribute, kAXSelectedAttribute,
    ]

    /// One IPC for all attributes (AXUIElementCopyMultipleAttributeValues) + one for actions.
    public func attrs() throws -> AXAttrs {
        var raw: CFArray?
        AXStats.shared.message()
        try axCheck(AXUIElementCopyMultipleAttributeValues(
            element, Self.batchNames as CFArray, AXCopyMultipleAttributeOptions(rawValue: 0), &raw))
        let v = (raw as? [AnyObject]) ?? []
        func at(_ i: Int) -> AnyObject? { i < v.count ? v[i] : nil }
        var names: CFArray?
        AXStats.shared.message()
        let actions = AXUIElementCopyActionNames(element, &names) == .success ? ((names as? [String]) ?? []) : []
        return AXAttrs(
            role: at(0) as? String, subrole: at(1) as? String, title: at(2) as? String,
            desc: at(3) as? String, help: at(4) as? String, identifier: at(5) as? String,
            value: at(6).flatMap(Self.scalar), valueDescription: at(7) as? String,
            enabled: (at(8) as? NSNumber)?.boolValue, selected: (at(9) as? NSNumber)?.boolValue,
            actions: actions)
    }

    /// Missing attributes come back as AXValue error objects and map to nil.
    public static func scalar(_ obj: AnyObject) -> AXScalar? {
        if let s = obj as? String { return .string(s) }
        if let n = obj as? NSNumber {
            return CFGetTypeID(n) == CFBooleanGetTypeID() ? .bool(n.boolValue) : .number(n.doubleValue)
        }
        return nil
    }

    public func children() throws -> [any AXNode] {
        var raw: AnyObject?
        AXStats.shared.message()
        let err = AXUIElementCopyAttributeValue(element, kAXChildrenAttribute as CFString, &raw)
        if err == .noValue || err == .attributeUnsupported { return [] }
        try axCheck(err)
        guard let arr = raw as? [AXUIElement] else { return [] }
        return arr.map { LiveAXNode($0, timeout: timeout) }
    }

    public func perform(_ action: String) throws {
        AXStats.shared.message()
        try axCheck(AXUIElementPerformAction(element, action as CFString))
    }

    public func set(_ attribute: String, _ value: AXScalar) throws {
        let cf: CFTypeRef
        switch value {
        case .string(let s): cf = s as CFString
        case .number(let d): cf = NSNumber(value: d)
        case .bool(let b): cf = (b ? kCFBooleanTrue : kCFBooleanFalse)!
        }
        AXStats.shared.message()
        try axCheck(AXUIElementSetAttributeValue(element, attribute as CFString, cf))
    }

    public func attributeNames() throws -> [String] {
        var names: CFArray?
        AXStats.shared.message()
        try axCheck(AXUIElementCopyAttributeNames(element, &names))
        return (names as? [String]) ?? []
    }

    /// Any attribute rendered with `String(describing:)` — for spikes (AXFrame, AXPosition, …).
    public func rawAttribute(_ name: String) throws -> String? {
        var raw: AnyObject?
        AXStats.shared.message()
        let err = AXUIElementCopyAttributeValue(element, name as CFString, &raw)
        if err == .noValue || err == .attributeUnsupported { return nil }
        try axCheck(err)
        return raw.map { String(describing: $0) }
    }

    public func setRaw(_ name: String, bool: Bool) throws {
        AXStats.shared.message()
        try axCheck(AXUIElementSetAttributeValue(element, name as CFString, (bool ? kCFBooleanTrue : kCFBooleanFalse)!))
    }

    public var identityToken: Int { Int(truncatingIfNeeded: CFHash(element)) }
}

public struct LiveAXRoot: AXRoot, @unchecked Sendable {
    public let pid: pid_t
    let app: AXUIElement
    let timeout: Float

    public init(pid: pid_t, timeout: Float = 1.0) {
        self.pid = pid
        self.app = AXUIElementCreateApplication(pid)
        self.timeout = timeout
        AXUIElementSetMessagingTimeout(app, timeout)
    }

    public var appNode: LiveAXNode { LiveAXNode(app, timeout: timeout) }

    func element(_ attr: String) throws -> (any AXNode)? {
        var raw: AnyObject?
        AXStats.shared.message()
        let err = AXUIElementCopyAttributeValue(app, attr as CFString, &raw)
        if err == .noValue || err == .attributeUnsupported { return nil }
        try axCheck(err)
        guard let raw, CFGetTypeID(raw) == AXUIElementGetTypeID() else { return nil }
        return LiveAXNode(raw as! AXUIElement, timeout: timeout)
    }

    public func mainWindow() throws -> (any AXNode)? { try element(kAXMainWindowAttribute) }
    public func focusedWindow() throws -> (any AXNode)? { try element(kAXFocusedWindowAttribute) }
    public func menuBar() throws -> (any AXNode)? { try element(kAXMenuBarAttribute) }
}
