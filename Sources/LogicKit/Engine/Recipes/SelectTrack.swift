import Foundation

public enum SelectStrategy: String, Sendable { case setSelected, pressRow, pressName, pressRadio, unsupported }

public struct SelectTrack: Recipe, TrackSelecting {
    /// From spikes-2026-09.md «Решения для P1» (S8).
    public static let strategy: SelectStrategy = .setSelected
    /// S8: true if selecting a track record-arms it (Auto Track Enable) and the arm must be put back.
    public static let restoresArm = false

    public let track: Int
    public init(track: Int) { self.track = track }
    public var spec: RecipeSpec { RecipeSpec(name: "track.select", reversible: false) }

    public func run(_ ctx: RecipeContext) throws -> Outcome {
        try select(track, ctx: ctx)
        return .ok(path: "track:\(track)", actual: "selected")
    }

    public func select(_ number: Int, ctx: RecipeContext) throws {
        let L = ctx.env.locale, root = ctx.env.root
        if try TrackReader.selectedNumber(root, L) == number { return }
        let row = try TrackReader.row(number: number, root, L)
        let armBox = try row.firstDescendant(AXMatch(role: "AXCheckBox", desc: .equals(L[.recordEnable])), maxDepth: 4)
        let armBefore = try armBox.map { boolValue(try $0.attrs().value) } ?? nil
        switch Self.strategy {
        case .setSelected: try row.set("AXSelected", .bool(true))
        case .pressRow: try Primitives.press(row)
        case .pressName:
            guard let name = try row.firstDescendant(AXMatch(role: "AXStaticText"), maxDepth: 3)
                    ?? row.firstDescendant(AXMatch(role: "AXTextField"), maxDepth: 3) else { throw LogicError.anchorMissing("track name field") }
            try Primitives.press(name)
        case .pressRadio:
            guard let radio = try row.firstDescendant(AXMatch(role: "AXRadioButton"), maxDepth: 3) else { throw LogicError.anchorMissing("track focus radio") }
            try Primitives.press(radio)
        case .unsupported:
            throw LogicError.unsupported("invisible track select is unavailable; select track \(number) in Logic")
        }
        let r = try Verify.poll(deadline: ctx.env.clock.now() + 1.0, clock: ctx.env.clock,
                                read: { try TrackReader.selectedNumber(root, L) }, done: { $0 == number })
        guard r.ok else { throw LogicError.verifyFailed(want: "track:\(number) selected", got: r.value.map { "track:\($0) selected" } ?? "none selected") }
        if Self.restoresArm, let armBox, let armBefore, boolValue(try armBox.attrs().value) != armBefore {
            try Primitives.press(armBox)
        }
    }
}
