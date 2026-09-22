import Foundation

public enum ValueUnit: String, Codable, Sendable {
    case dB, pan, ms, seconds, percent, onOff, number, text, position
}

public struct BarPosition: Comparable, Sendable, CustomStringConvertible {
    public var bar: Int, beat: Int, division: Int, tick: Int

    public init(bar: Int, beat: Int = 1, division: Int = 1, tick: Int = 1) {
        self.bar = bar; self.beat = beat; self.division = division; self.tick = tick
    }

    /// "17 1 1 1", "17.3.1.1" or "17"; missing trailing parts default to 1.
    public static func parse(_ s: String) -> BarPosition? {
        let parts = s.split(whereSeparator: { $0 == " " || $0 == "." })
        guard (1...4).contains(parts.count) else { return nil }
        var nums = parts.compactMap { Int($0) }
        guard nums.count == parts.count, nums.dropFirst().allSatisfy({ $0 >= 1 }) else { return nil }
        while nums.count < 4 { nums.append(1) }
        return BarPosition(bar: nums[0], beat: nums[1], division: nums[2], tick: nums[3])
    }

    public var description: String { "\(bar) \(beat) \(division) \(tick)" }

    public static func < (a: BarPosition, b: BarPosition) -> Bool {
        (a.bar, a.beat, a.division, a.tick) < (b.bar, b.beat, b.division, b.tick)
    }
}

public enum LogicValue: Equatable, Sendable {
    case dB(Double), pan(Int), ms(Double), seconds(Double), percent(Double)
    case bool(Bool), number(Double), text(String), position(BarPosition)
}

public struct ValueError: Error, Equatable {
    public let message: String
    public init(_ m: String) { message = m }
}

public enum ValueParser {
    public static func parse(_ raw: String, unit: ValueUnit) throws -> LogicValue {
        let s = raw.trimmingCharacters(in: .whitespaces)
        let low = s.lowercased()
        func num(_ t: some StringProtocol) -> Double? {
            Double(t.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: "."))
        }
        switch unit {
        case .dB:
            let body = (low.hasSuffix("db") ? String(low.dropLast(2)) : low).trimmingCharacters(in: .whitespaces)
            if ["-inf", "-∞", "inf", "-infinity"].contains(body) { return .dB(-.infinity) }
            guard let v = num(body) else { throw ValueError("expected dB like \"-6 dB\" or \"-inf\", got \"\(raw)\"") }
            return .dB(v)
        case .pan:
            if ["c", "center", "centre", "0"].contains(low) { return .pan(0) }
            let v: Int?
            if low.hasPrefix("l") { v = Int(low.dropFirst()).map { -$0 } }
            else if low.hasPrefix("r") { v = Int(low.dropFirst()) }
            else { v = Int(low.hasPrefix("+") ? String(low.dropFirst()) : low) }
            guard let p = v, (-64...63).contains(p) else { throw ValueError("expected pan L64…C…R63, got \"\(raw)\"") }
            return .pan(p)
        case .ms:
            if low.hasSuffix("ms"), let v = num(low.dropLast(2)) { return .ms(v) }
            if low.hasSuffix("s"), let v = num(low.dropLast(1)) { return .ms(v * 1000) }
            if let v = num(low) { return .ms(v) }
            throw ValueError("expected time like \"38 ms\", got \"\(raw)\"")
        case .seconds:
            if low.hasSuffix("ms"), let v = num(low.dropLast(2)) { return .seconds(v / 1000) }
            if low.hasSuffix("s"), let v = num(low.dropLast(1)) { return .seconds(v) }
            if let v = num(low) { return .seconds(v) }
            throw ValueError("expected time like \"1.6 s\", got \"\(raw)\"")
        case .percent:
            guard let v = num(low.hasSuffix("%") ? String(low.dropLast()) : low) else { throw ValueError("expected percent like \"20%\", got \"\(raw)\"") }
            return .percent(v)
        case .onOff:
            if ["on", "true", "1", "yes"].contains(low) { return .bool(true) }
            if ["off", "false", "0", "no"].contains(low) { return .bool(false) }
            throw ValueError("expected on|off, got \"\(raw)\"")
        case .number:
            guard let v = num(low) else { throw ValueError("expected a number, got \"\(raw)\"") }
            return .number(v)
        case .text:
            return .text(s)
        case .position:
            guard let p = BarPosition.parse(s) else { throw ValueError("expected position like \"17 1 1 1\", got \"\(raw)\"") }
            return .position(p)
        }
    }

    /// Lenient parse of an AXValueDescription.
    public static func parseDisplay(_ raw: String, unit: ValueUnit) -> LogicValue? {
        if let v = try? parse(raw, unit: unit) { return v }
        if unit == .pan, let d = Double(raw.trimmingCharacters(in: .whitespaces)) { return .pan(Int(d.rounded())) }
        return nil
    }

    public static func format(_ v: LogicValue) -> String {
        switch v {
        case .dB(let d): return d == -.infinity ? "-inf dB" : "\(trim(d)) dB"
        case .pan(let p): return p == 0 ? "C" : p < 0 ? "L\(-p)" : "R\(p)"
        case .ms(let d): return "\(trim(d)) ms"
        case .seconds(let d): return "\(trim(d)) s"
        case .percent(let d): return "\(trim(d))%"
        case .bool(let b): return b ? "on" : "off"
        case .number(let d): return trim(d)
        case .text(let s): return s
        case .position(let p): return p.description
        }
    }

    public static func magnitude(_ v: LogicValue) -> Double? {
        switch v {
        case .dB(let d), .ms(let d), .seconds(let d), .percent(let d), .number(let d): return d
        case .pan(let p): return Double(p)
        case .bool(let b): return b ? 1 : 0
        case .text, .position: return nil
        }
    }

    static func trim(_ d: Double) -> String {
        if d == d.rounded(), abs(d) < 1e12 { return String(Int(d)) }
        return String(format: "%.2f", d).replacingOccurrences(of: #"0+$"#, with: "", options: .regularExpression)
    }
}
