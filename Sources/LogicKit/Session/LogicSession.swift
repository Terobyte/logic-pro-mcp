import Foundation

public final class LogicSession: @unchecked Sendable {
    public let executor: AXExecutor
    public let locale: LocaleTable
    public let handles = HandleTable()
    let ledger: Ledger
    let rootFactory: @Sendable () throws -> any AXRoot
    let pidProvider: @Sendable () -> pid_t?
    let logicMinor: @Sendable () -> String?

    public init(locale: LocaleTable = .en, executor: AXExecutor, ledger: Ledger = .bundled(),
                rootFactory: @escaping @Sendable () throws -> any AXRoot, pidProvider: @escaping @Sendable () -> pid_t?,
                logicMinor: @escaping @Sendable () -> String? = { LogicApp.version().map(LogicApp.minor) }) {
        self.locale = locale; self.executor = executor; self.ledger = ledger
        self.rootFactory = rootFactory; self.pidProvider = pidProvider; self.logicMinor = logicMinor
    }

    public static func live(locale: LocaleTable = .en) -> LogicSession {
        LogicSession(
            locale: locale,
            executor: AXExecutor(healthProbe: {
                guard let pid = LogicApp.pid else { return false }
                return (try? LiveAXRoot(pid: pid, timeout: 0.25).mainWindow()) != nil
            }),
            rootFactory: {
                guard LogicApp.axTrusted else { throw LogicError.permissionAX }
                guard let pid = LogicApp.pid else { throw LogicError.logicNotRunning }
                return LiveAXRoot(pid: pid)
            },
            pidProvider: { LogicApp.pid })
    }

    var advertised: [Capability] { Grammar.advertised(ledger: ledger, logicMinor: logicMinor()) }

    func onAX<T: Sendable>(_ transaction: Bool = false, _ body: @escaping @Sendable (any AXRoot) throws -> T) async throws -> T {
        let factory = rootFactory
        do {
            let job: @Sendable () throws -> T = { try body(try factory()) }
            return transaction ? try await executor.transaction(job) : try await executor.read(job)
        } catch ExecutorError.busy {
            throw LogicError.busy("Logic is not responding (bounce or loading?)")
        } catch let e as LogicError {
            throw e
        } catch {
            throw RecipeRunner.map(error)
        }
    }

    // MARK: read

    public func read(_ path: String, depth: Int = 1, fields: [String]? = nil, page: String? = nil) async throws -> String {
        let p = Resolver.canonical(try LPath.parse(path))
        let options = RenderOptions(page: try page.map(RenderOptions.parsePage), fields: fields)
        if let bad = fields?.first(where: { !TextRenderer.fieldNames.contains($0) }) {
            throw LogicError.invalidArgs(signature: "fields: " + TextRenderer.fieldNames.joined(separator: ","), detail: "unknown field \(bad)")
        }
        let caps = advertised
        let L = locale, handles = handles, version = LogicApp.version()
        return try await onAX { root in
            let kinds = p.segments.map(\.kind)
            switch kinds {
            case []:
                let tracks = try TrackReader.read(root, L)
                var warnings: [String] = []
                if let modal = try ModalGuard.modalTitle(root, L) { warnings.append("modal \"\(modal)\" is open") }
                return TextRenderer.root(project: try ProjectReader.read(root, version: version),
                                         transport: try? TransportReader.read(root, L), tracks: tracks,
                                         handles: Resolver.handles(for: tracks, table: handles), options: options, warnings: warnings)
            case [.transport]:
                return TextRenderer.transport(try TransportReader.read(root, L))
            case [.system]:
                let missing = try AnchorProbe.missing(root, L).map(\.rawValue)
                var s = "system logic=\(version ?? "?") ax=granted advertised=\(caps.count)"
                if !missing.isEmpty { s += "\n⚠ anchors missing: " + missing.joined(separator: ", ") }
                if caps.isEmpty { s += "\n⚠ this Logic version has no live-verified capabilities" }
                return s
            case [.system, .schema]:
                guard case .id(let k)? = p.segments[1].selector, let kind = NodeKind(rawValue: k) else { throw LogicError.invalidArgs(signature: "system/schema/<kind>", detail: "bad kind") }
                return Grammar.schema(kind, caps: caps)
            case [.track], [.track, .strip], [.track, .raw]:
                let tracks = try TrackReader.read(root, L)
                let (t, note) = try Resolver.track(p.segments[0].selector!, in: tracks, table: handles)
                let hs = Resolver.handles(for: tracks, table: handles)
                let handle = hs[tracks.firstIndex(of: t)!]
                if kinds.last == .raw {
                    return try Self.raw(TrackReader.row(number: t.number, root, L), depth: max(depth, 1))
                }
                let strip = t.selected ? try StripReader.inspector(root, L) : nil
                var text = kinds.last == .strip
                    ? (t.selected && strip != nil ? String(TextRenderer.strip(strip!).dropFirst()) : "?unavailable(need_select: logic_do track:\(t.number) select)")
                    : TextRenderer.track(t, handle: handle, strip: strip)
                if let note { text += "\n\(note)" }
                return text
            default:
                throw LogicError.unsupported("reading \(p) is not available yet")
            }
        }
    }

    static func raw(_ node: any AXNode, depth: Int) throws -> String {
        var lines: [String] = []
        func walk(_ n: any AXNode, _ d: Int, _ indent: Int) throws {
            guard lines.count < 60 else { return }
            lines.append(String(repeating: " ", count: indent) + (try n.attrs().compactLine))
            guard d > 0 else { return }
            for c in try n.children() { try walk(c, d - 1, indent + 1) }
        }
        try walk(node, depth, 0)
        if lines.count >= 60 { lines.append("… (truncated at 60 nodes; read a deeper path)") }
        return lines.joined(separator: "\n")
    }

    // MARK: set / do

    func resolveTarget(_ p: LPath, root: any AXRoot) throws -> (kind: NodeKind, track: Int?) {
        guard let first = p.segments.first else { return (.root, nil) }
        if first.kind == .track {
            let (t, _) = try Resolver.track(first.selector!, in: try TrackReader.read(root, locale), table: handles)
            return (.track, t.number)
        }
        return (p.segments.last!.kind, nil)
    }

    func env(_ root: any AXRoot) -> RecipeEnv { RecipeEnv(root: root, locale: locale, logicPID: pidProvider()) }

    public func set(_ assigns: [(path: String, value: String)]) async throws -> String {
        var done: [String] = []
        for (path, raw) in assigns {
            do {
                let p = Resolver.canonical(try LPath.parse(path))
                guard let name = p.property else { throw LogicError.invalidArgs(signature: "assign: [{path: \"track:N/mute\", value: \"on\"}]", detail: "path must end with a property") }
                let kind = p.segments.last?.kind ?? .root
                guard let cap = advertised.first(where: { $0.kind == kind && $0.name == name }), case .property(let unit) = cap.form else {
                    throw LogicError.unsupported("\(kind.rawValue)/\(name) is not live-verified")
                }
                let value: LogicValue
                do { value = try ValueParser.parse(raw, unit: unit) }
                catch let e as ValueError { throw LogicError.invalidValue(want: raw, range: e.message) }
                let text = try await onAX(true) { [self] root in
                    let target = try self.resolveTarget(p, root: root)
                    let recipe = try RecipeRegistry.property(kind, name, track: target.track, value: value)
                    return try RecipeRunner.run(recipe, env: self.env(root), restorer: SelectTrack(track: 0)).text
                }
                done.append(text)
            } catch let e as LogicError {
                if done.isEmpty { throw e }
                throw LogicError.partial(done: done, failed: "\(path): \(e.code)", undoSteps: nil)
            }
        }
        return done.joined(separator: "\n")
    }

    public func perform(steps: [(path: String, action: String, args: [String: String])]) async throws -> String {
        var done: [String] = []
        for (path, action, args) in steps {
            do {
                let p = Resolver.canonical(try LPath.parse(path))
                let kind = p.segments.last?.kind ?? .root
                guard advertised.contains(where: { $0.kind == kind && $0.name == action }) else {
                    throw LogicError.unsupported("\(kind.rawValue) \(action) is not live-verified")
                }
                let text = try await onAX(true) { [self] root in
                    let target = try self.resolveTarget(p, root: root)
                    let recipe = try RecipeRegistry.action(kind, action, track: target.track, args: args)
                    return try RecipeRunner.run(recipe, env: self.env(root), restorer: SelectTrack(track: 0)).text
                }
                if action == "undo" || action == "redo" { handles.reset() }   // structural change (spec §4.4)
                done.append(text)
            } catch let e as LogicError {
                if done.isEmpty { throw e }
                throw LogicError.partial(done: done, failed: "\(path) \(action): \(e.code)", undoSteps: nil)
            }
        }
        return done.joined(separator: "\n")
    }
}
