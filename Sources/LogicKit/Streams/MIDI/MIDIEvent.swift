public enum MIDIEvent: Equatable, Sendable {
    case note(ch: Int, note: Int, vel: Int, durMs: Int)
    case cc(ch: Int, cc: Int, value: Int)
    case pc(ch: Int, program: Int)
    case pitchBend(ch: Int, value: Int)

    var channel: Int {
        switch self { case .note(let c, _, _, _), .cc(let c, _, _), .pc(let c, _), .pitchBend(let c, _): return c }
    }

    public func validate() throws {
        func r(_ v: Int, _ range: ClosedRange<Int>, _ what: String) throws {
            guard range.contains(v) else { throw LogicError.invalidValue(want: "\(what)=\(v)", range: "\(range.lowerBound)…\(range.upperBound)") }
        }
        try r(channel, 1...16, "ch")
        switch self {
        case .note(_, let n, let v, let d): try r(n, 0...127, "note"); try r(v, 1...127, "vel"); try r(d, 1...60000, "dur_ms")
        case .cc(_, let c, let v): try r(c, 0...127, "cc"); try r(v, 0...127, "value")
        case .pc(_, let p): try r(p, 0...127, "program")
        case .pitchBend(_, let v): try r(v, 0...16383, "value")
        }
    }

    public var onBytes: [UInt8] {
        let ch = UInt8(channel - 1)
        switch self {
        case .note(_, let n, let v, _): return [0x90 | ch, UInt8(n), UInt8(v)]
        case .cc(_, let c, let v): return [0xB0 | ch, UInt8(c), UInt8(v)]
        case .pc(_, let p): return [0xC0 | ch, UInt8(p)]
        case .pitchBend(_, let v): return [0xE0 | ch, UInt8(v & 0x7F), UInt8(v >> 7)]
        }
    }

    public var offBytes: [UInt8]? {
        guard case .note(let c, let n, _, _) = self else { return nil }
        return [0x80 | UInt8(c - 1), UInt8(n), 0]
    }
}
