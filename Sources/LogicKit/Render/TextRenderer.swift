import Foundation

public struct RenderOptions: Equatable, Sendable {
    public var page: ClosedRange<Int>?
    public var fields: [String]?
    public var maxRows = 12
    public init(page: ClosedRange<Int>? = nil, fields: [String]? = nil) { self.page = page; self.fields = fields }

    public static func parsePage(_ s: String) throws -> ClosedRange<Int> {
        let p = s.split(separator: "-").compactMap { Int($0) }
        guard p.count == 2, p[0] >= 1, p[0] <= p[1] else {
            throw LogicError.invalidArgs(signature: "page: \"FROM-TO\", e.g. \"13-24\"", detail: "bad page \(s)")
        }
        return p[0]...p[1]
    }
}

public enum TextRenderer {
    public static let fieldNames = ["name", "kind", "mute", "solo", "arm", "selected", "volume", "pan", "takes"]

    static func compact(_ s: String) -> String { s.replacingOccurrences(of: " ", with: "") }
    static func onOff(_ b: Bool?) -> String { b.map { $0 ? "on" : "off" } ?? "?" }

    public static func trackLine(_ t: TrackInfo, handle: String) -> String {
        var s = "track:\(t.number) \(handle) \"\(t.name)\""
        if t.kind != .unknown { s += " \(t.kind.rawValue)" }
        let toggles = [t.mute == true ? "M" : "", t.solo == true ? "S" : "", t.arm == true ? "R" : ""].joined()
        if !toggles.isEmpty { s += " \(toggles)" }
        if let v = t.volume { s += " vol=\(compact(v))" }
        if let p = t.pan, !["0", "C", "0.0"].contains(p) { s += " pan=\(compact(p))" }
        if t.takeLanes > 0 { s += " takes:\(t.takeLanes)" }
        if t.selected { s += " [selected]" }
        if !t.hasOutput { s += " ⚠ no output" }
        return s
    }

    public static func fields(_ t: TrackInfo, _ f: [String]) -> String {
        var parts = ["track:\(t.number)"]
        for name in f {
            switch name {
            case "name": parts.append("\"\(t.name)\"")
            case "kind": parts.append("kind=\(t.kind.rawValue)")
            case "mute": parts.append("mute=\(onOff(t.mute))")
            case "solo": parts.append("solo=\(onOff(t.solo))")
            case "arm": parts.append("arm=\(onOff(t.arm))")
            case "selected": parts.append("selected=\(onOff(t.selected))")
            case "volume": parts.append("vol=\(t.volume.map(compact) ?? "?")")
            case "pan": parts.append("pan=\(t.pan.map(compact) ?? "?")")
            case "takes": parts.append("takes=\(t.takeLanes)")
            default: break
            }
        }
        return parts.joined(separator: " ")
    }

    /// Spec §4.6: at most maxRows; priority rows first, then in order. Returns rows in original order.
    public static func fold<T>(_ items: [T], priority: (T) -> Bool, options: RenderOptions) -> (shown: [T], hidden: Int) {
        if let page = options.page {
            let lo = page.lowerBound - 1, hi = min(page.upperBound, items.count)
            return lo < hi ? (Array(items[lo..<hi]), items.count - (hi - lo)) : ([], items.count)
        }
        guard items.count > options.maxRows else { return (items, 0) }
        var chosen = Array(items.indices.filter { priority(items[$0]) }.prefix(options.maxRows))
        for i in items.indices where chosen.count < options.maxRows && !chosen.contains(i) { chosen.append(i) }
        return (chosen.sorted().map { items[$0] }, items.count - chosen.count)
    }

    public static func transport(_ t: TransportInfo?) -> String {
        guard let t, let state = t.state else { return "transport ?unavailable" }
        return "transport \(state.rawValue) pos=\(t.position ?? "?")" + (t.cycle == true ? " cycle" : "")
    }

    public static func root(project: ProjectInfo, transport t: TransportInfo?, tracks: [TrackInfo], handles: [String],
                            options: RenderOptions, warnings: [String] = []) -> String {
        var lines = ["/ \"\(project.name)\"" + (project.logicVersion.map { " logic=\($0)" } ?? ""), transport(t)]
        lines += warnings.map { "⚠ \($0)" }
        let pairs = Array(zip(tracks, handles))
        if let f = options.fields {
            lines.append("tracks:\(tracks.count)")
            lines += pairs.map { " " + fields($0.0, f) }
            return lines.joined(separator: "\n")
        }
        let (shown, hidden) = fold(pairs, priority: { $0.0.selected || $0.0.arm == true || $0.0.solo == true || !$0.0.hasOutput }, options: options)
        if hidden > 0 {
            let start = (options.page?.upperBound ?? options.maxRows) + 1
            let end = min(start + options.maxRows - 1, tracks.count)
            let hint = start <= tracks.count ? "page:\"\(start)-\(end)\" or " : ""
            lines.append("tracks:\(tracks.count) (showing \(shown.count); \(hint)fields:\"name,mute\")")
        } else {
            lines.append("tracks:\(tracks.count)")
        }
        lines += shown.map { " " + trackLine($0.0, handle: $0.1) }
        return lines.joined(separator: "\n")
    }

    public static func strip(_ s: StripInfo) -> String {
        var head = " strip"
        if let v = s.volume { head += " vol=\(compact(v))" }
        if let p = s.pan { head += " pan=\(compact(p))" }
        if let pk = s.peak { head += " peak=\(compact(pk))" }
        let inserts = s.inserts.isEmpty ? " insert: none"
            : " insert:" + s.inserts.map { "\($0.slot) \($0.name)" + ($0.bypassed == true ? "(bypass)" : "") }.joined(separator: " · ")
        return head + "\n" + inserts
    }

    /// `strip` is nil when the track is not selected (spec §4.2).
    public static func track(_ t: TrackInfo, handle: String, strip s: StripInfo?) -> String {
        let body = t.selected && s != nil ? strip(s!) : " strip ?unavailable(need_select: logic_do track:\(t.number) select)"
        return trackLine(t, handle: handle) + "\n" + body
    }
}
