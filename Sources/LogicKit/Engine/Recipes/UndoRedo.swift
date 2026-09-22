import Foundation

public struct UndoRedo: Recipe {
    public enum Mode: Sendable { case undo, redo }
    /// From S9: whether AX shows a fresh "Undo …" title without opening the Edit menu.
    public static let titleFreshWithoutOpening = true

    public let mode: Mode, steps: Int
    public init(mode: Mode, steps: Int) { self.mode = mode; self.steps = steps }
    public var spec: RecipeSpec {
        RecipeSpec(name: mode == .undo ? "undo" : "redo", visibility: Self.titleFreshWithoutOpening ? .never : .transient,
                   idempotent: false, deadline: 2.0, allowWhilePlaying: false)
    }

    public func run(_ ctx: RecipeContext) throws -> Outcome {
        let L = ctx.env.locale
        guard let bar = try ctx.env.root.menuBar() else { throw LogicError.unavailable("no menu bar") }
        let (mine, other) = mode == .undo ? (L[.menuUndoPrefix], L[.menuRedoPrefix]) : (L[.menuRedoPrefix], L[.menuUndoPrefix])
        func item(_ prefix: String) throws -> (any AXNode)? {
            if !Self.titleFreshWithoutOpening, let edit = try bar.firstChild(AXMatch(title: .equals(L[.menuEdit]))) {
                try edit.perform("AXPress")
                defer { try? edit.perform("AXCancel") }
                return try MenuPath.resolve(menuBar: bar, path: [L[.menuEdit], "^" + prefix])
            }
            return try MenuPath.resolve(menuBar: bar, path: [L[.menuEdit], "^" + prefix])
        }
        var done: [String] = []
        for _ in 0..<steps {
            guard let it = try item(mine) else { throw LogicError.anchorMissing("Edit>\(mine)") }
            let a = try it.attrs()
            guard a.enabled != false, let title = a.title else {
                if done.isEmpty { throw LogicError.unavailable("nothing to \(mine.lowercased())") }
                break
            }
            let action = String(title.dropFirst(mine.count)).trimmingCharacters(in: .whitespaces)
            try ctx.checkpoint()
            try Primitives.press(it)
            // Verify: the opposite item now names the same action ("Undo X" → "Redo X").
            let r = try Verify.poll(deadline: ctx.env.clock.now() + spec.deadline, clock: ctx.env.clock,
                                    read: { try item(other)?.attrs().title ?? "" },
                                    done: { $0.trimmingCharacters(in: .whitespaces) == "\(other) \(action)".trimmingCharacters(in: .whitespaces) })
            guard r.ok else { throw LogicError.verifyFailed(want: "\(other) \(action)", got: r.value) }
            done.append(action)
        }
        let top = (try? item(L[.menuUndoPrefix])?.attrs().title) ?? nil
        return .ok(path: "/", actual: "\(mine.lowercased()) " + done.map { "\"\($0)\"" }.joined(separator: ", "),
                   notes: ["undo_title: \(top ?? "?")"])
    }
}
