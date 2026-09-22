import Foundation

public enum RecipeRegistry {
    static func need(_ track: Int?) throws -> Int {
        guard let track else { throw LogicError.invalidArgs(signature: "track:N", detail: "this action needs a track") }
        return track
    }

    public static func action(_ kind: NodeKind, _ name: String, track: Int?, args: [String: String]) throws -> any Recipe {
        switch (kind, name) {
        case (.track, "select"): return SelectTrack(track: try need(track))
        case (.root, "undo"), (.root, "redo"):
            guard let steps = Int(args["steps"] ?? "1"), (1...10).contains(steps) else {
                throw LogicError.invalidArgs(signature: "\(name) {steps?: 1..10}", detail: "bad steps \(args["steps"] ?? "")")
            }
            return UndoRedo(mode: name == "undo" ? .undo : .redo, steps: steps)
        case (.transport, "play"): return TransportCommand(command: .play)
        case (.transport, "stop"): return TransportCommand(command: .stop)
        default: throw LogicError.unsupported("\(kind.rawValue) has no action \(name)")
        }
    }

    public static func property(_ kind: NodeKind, _ name: String, track: Int?, value: LogicValue) throws -> any Recipe {
        switch (kind, name, value) {
        case (.track, "mute", .bool(let b)): return TrackToggle(track: try need(track), which: .mute, on: b)
        case (.track, "solo", .bool(let b)): return TrackToggle(track: try need(track), which: .solo, on: b)
        case (.transport, "position", .position(let p)): return Locate(position: p)
        default: throw LogicError.unsupported("\(kind.rawValue)/\(name) cannot be set")
        }
    }

    public static func has(_ c: Capability) -> Bool {
        switch c.form {
        case .read: return true
        case .action: return (try? action(c.kind, c.name, track: 1, args: [:])) != nil
        case .property(let unit):
            let sample: LogicValue = unit == .onOff ? .bool(true) : unit == .position ? .position(BarPosition(bar: 1)) : .number(0)
            return (try? property(c.kind, c.name, track: 1, value: sample)) != nil
        }
    }
}
