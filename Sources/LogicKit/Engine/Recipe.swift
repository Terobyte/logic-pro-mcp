import Foundation

public enum Visibility: String, Sendable, Codable { case never, transient, restores }

public struct RecipeSpec: Sendable {
    public var name: String
    public var visibility: Visibility
    public var idempotent: Bool
    public var reversible: Bool
    public var deadline: Double
    public var allowWhilePlaying: Bool
    public var allowWhileRecording: Bool
    public var changesSelection: Bool

    public init(name: String, visibility: Visibility = .never, idempotent: Bool = true, reversible: Bool = true,
                deadline: Double = 1.0, allowWhilePlaying: Bool = true, allowWhileRecording: Bool = false,
                changesSelection: Bool = false) {
        self.name = name; self.visibility = visibility; self.idempotent = idempotent; self.reversible = reversible
        self.deadline = deadline; self.allowWhilePlaying = allowWhilePlaying
        self.allowWhileRecording = allowWhileRecording; self.changesSelection = changesSelection
    }
}

public struct RecipeEnv: Sendable {
    public var root: any AXRoot
    public var locale: LocaleTable
    public var clock: Clock
    public var logicPID: pid_t?
    public init(root: any AXRoot, locale: LocaleTable, clock: Clock = .system, logicPID: pid_t? = nil) {
        self.root = root; self.locale = locale; self.clock = clock; self.logicPID = logicPID
    }
}

public protocol Recipe: Sendable {
    var spec: RecipeSpec { get }
    /// Runs on the AX thread inside one transaction and verifies its own postcondition.
    func run(_ ctx: RecipeContext) throws -> Outcome
}

public protocol TrackSelecting: Sendable {
    func select(_ number: Int, ctx: RecipeContext) throws
}

public final class RecipeContext {
    public let env: RecipeEnv
    public private(set) var notes: [String] = []
    public var expectedSelection: Int?

    init(env: RecipeEnv) { self.env = env }

    public func note(_ s: String) { notes.append(s) }

    /// Spec §5.4: context readback before every mutating step.
    public func checkpoint() throws {
        if let title = try ModalGuard.modalTitle(env.root, env.locale) { throw LogicError.blocked(.modal(title)) }
        if let want = expectedSelection {
            let now = try TrackReader.selectedNumber(env.root, env.locale)
            if now != want { throw LogicError.blocked(.contextChanged("selection \(want)→\(now.map(String.init) ?? "none")")) }
        }
    }
}

public enum RecipeRunner {
    public static func run(_ recipe: any Recipe, env: RecipeEnv, restorer: (any TrackSelecting)? = nil) throws -> Outcome {
        let spec = recipe.spec
        let ctx = RecipeContext(env: env)
        if let title = try ModalGuard.modalTitle(env.root, env.locale) { throw LogicError.blocked(.modal(title)) }
        if !spec.allowWhilePlaying || !spec.allowWhileRecording {
            let state = (try? TransportReader.read(env.root, env.locale))?.state
            if state == .recording && !spec.allowWhileRecording { throw LogicError.blocked(.recording) }
            if state == .playing && !spec.allowWhilePlaying { throw LogicError.blocked(.playing) }
        }
        let before = try env.logicPID.map { try WindowSnapshot.capture(logicPID: $0, root: env.root) }
        let original = spec.changesSelection ? try TrackReader.selectedNumber(env.root, env.locale) : nil

        let result: Result<Outcome, Error>
        do { result = .success(try recipe.run(ctx)) } catch { result = .failure(error) }

        // Teardown is identical on success and on error (spec §5.4).
        if spec.changesSelection, let original, let restorer {
            ctx.expectedSelection = nil
            do { try restorer.select(original, ctx: ctx) } catch {
                let now = (try? TrackReader.selectedNumber(env.root, env.locale)) ?? nil
                ctx.note("⚠ selection left on \(now.map(String.init) ?? "none") (was \(original))")
                Log.warn("selection restore failed: \(error)", subsystem: "recipe")
            }
        }
        if let before, let pid = env.logicPID, let after = try? WindowSnapshot.capture(logicPID: pid, root: env.root) {
            let diff = before.diff(to: after)
            if spec.visibility == .never && !diff.isClean { ctx.note("⚠ window side effect: \(diff.summary)") }
        }
        switch result {
        case .success(let outcome): return outcome.appending(notes: ctx.notes)
        case .failure(let error): throw map(error)
        }
    }

    public static func map(_ e: Error) -> Error {
        switch e {
        case let e as LogicError: return e
        case AXCallError.timeout: return AXCallError.timeout   // AXExecutor turns this into busy
        case AXCallError.invalidElement: return LogicError.blocked(.contextChanged("UI element vanished during the operation"))
        case AXCallError.readOnlyFixture: return LogicError.unsupported("fixture is read-only")
        case let e as AXCallError: return LogicError.unavailable("AX error: \(e)")
        default: return e
        }
    }
}
