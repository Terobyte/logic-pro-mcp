import Foundation

public struct TransportCommand: Recipe {
    public enum Command: String, Sendable { case play, stop }
    public let command: Command
    public init(command: Command) { self.command = command }
    public var spec: RecipeSpec {
        RecipeSpec(name: "transport.\(command.rawValue)", reversible: false, deadline: 1.5, allowWhileRecording: command == .stop)
    }

    public func run(_ ctx: RecipeContext) throws -> Outcome {
        let L = ctx.env.locale, root = ctx.env.root
        let want: TransportState = command == .play ? .playing : .stopped
        if try TransportReader.read(root, L).state == want { return .ok(path: "transport", actual: want.rawValue) }
        guard let button = try TransportReader.controlBar(root, L)
                .firstDescendant(AXMatch(desc: .equals(L[command == .play ? .play : .stop])), maxDepth: 5) else {
            throw LogicError.anchorMissing(command.rawValue)
        }
        try ctx.checkpoint()
        try Primitives.press(button)
        let r = try Verify.poll(deadline: ctx.env.clock.now() + spec.deadline, clock: ctx.env.clock,
                                read: { try TransportReader.read(root, L).state }, done: { $0 == want })
        guard r.ok else { throw LogicError.verifyFailed(want: want.rawValue, got: r.value?.rawValue ?? "?") }
        return .ok(path: "transport", actual: want.rawValue)
    }
}

public struct Locate: Recipe {
    public let position: BarPosition
    public init(position: BarPosition) { self.position = position }
    public var spec: RecipeSpec { RecipeSpec(name: "transport.position", reversible: false, allowWhilePlaying: false) }

    public func run(_ ctx: RecipeContext) throws -> Outcome {
        let L = ctx.env.locale, root = ctx.env.root
        guard let field = try TransportReader.controlBar(root, L).firstDescendant(AXMatch(desc: .equals(L[.positionField])), maxDepth: 6) else {
            throw LogicError.anchorMissing("positionField")
        }
        try ctx.checkpoint()
        try Primitives.setText(field, position.description)
        let r = try Verify.poll(deadline: ctx.env.clock.now() + spec.deadline, clock: ctx.env.clock,
                                read: { try TransportReader.read(root, L).position ?? "" },
                                done: { BarPosition.parse($0) == position })
        guard r.ok else { throw LogicError.verifyFailed(want: position.description, got: r.value) }
        return .ok(path: "transport/position", actual: position.description)
    }
}
