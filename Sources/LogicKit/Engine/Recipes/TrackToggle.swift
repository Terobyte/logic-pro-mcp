import Foundation

/// Toggles are always a set (spec §5.3): read → press only if different → verify.
public struct TrackToggle: Recipe {
    public enum Which: String, Sendable { case mute, solo }
    public let track: Int, which: Which, on: Bool
    public init(track: Int, which: Which, on: Bool) { self.track = track; self.which = which; self.on = on }
    public var spec: RecipeSpec { RecipeSpec(name: "track.\(which.rawValue)") }

    public func run(_ ctx: RecipeContext) throws -> Outcome {
        let L = ctx.env.locale
        let path = "track:\(track)/\(which.rawValue)"
        let want = on ? "on" : "off"
        let row = try TrackReader.row(number: track, ctx.env.root, L)
        guard let box = try row.firstDescendant(AXMatch(role: "AXCheckBox", desc: .equals(L[which == .mute ? .mute : .solo])), maxDepth: 4) else {
            throw LogicError.unavailable("track:\(track) has no \(which.rawValue) button")
        }
        if boolValue(try box.attrs().value) == on { return .ok(path: path, actual: want) }
        try ctx.checkpoint()
        try Primitives.press(box)
        let r = try Verify.poll(deadline: ctx.env.clock.now() + spec.deadline, clock: ctx.env.clock,
                                read: { boolValue(try box.attrs().value) }, done: { $0 == on })
        guard r.ok else { throw LogicError.verifyFailed(want: want, got: r.value.map { $0 ? "on" : "off" } ?? "?") }
        return .ok(path: path, actual: want)
    }
}
